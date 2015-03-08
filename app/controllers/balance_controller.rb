require 'stripe'

class BalanceController < ApplicationController    
  before_action :get_user
  
  rescue_from ActionController::ParameterMissing do
    render json: { :msg => "Invalid Request."}, :status => 400
  end
    
  #POST /deposit
  def deposit
      params.permit(:stripe_token, :amount)

      if params[:amount] < 0
        render json: { msg: "Invalid amount."}, status: 406 and return
      end
      
      begin
        Stripe::Charge.create(
          :amount => params[:amount],
          :currency => "usd",
          :source => params[:stripe_token],
          :description => "Deposit for #{@user.email}"
        )
      rescue Stripe::CardError => e
        # The card has been declined
        body = e.json_body
        err  = body[:error]
        render json: { msg: "Failed to charge, #{err[:message]}"}, status: 406 and return
      rescue Stripe::APIConnectionError => e
        # Network communication with Stripe failed
        render json: { msg: "The payment system is not avaiable at this time."}, status: 500 and return
      rescue Stripe::InvalidRequestError => e
        body = e.json_body
        err  = body[:error]
        render json: { msg: "#{err[:message]}"}, status: 406 and return
      end
      
      @user.balance += params[:amount]
      @user.save
      render json: {}, status: 200
  end

  #POST /transfer
  def transfer
      params.permit(:target_user, :amount)

      target_user = User.where(email: params[:target_user]).first

      #check the balance
      if @user.balance >= params[:amount]
        if target_user
            target_user.balance += params[:amount]
            target_user.save
            
            @user.balance -= params[:amount]
            @user.save
        else
            render json: { msg: "Target account doesn't exist."}, status: 406
        end
      else
        render json: { msg: "Your balance is insufficient." }, status: 402
      end
  end

  #POST /withdraw
  def withdraw
      params.permit(:full_name, :amount, :stripe_token)
  
      #check the balance
      if @user.balance >= params[:amount]          
          begin
            user_recipient = Stripe::Recipient.create(
                            :name => params[:full_name],
                            :type => "individual",
                            :bank_account => params[:stripe_token],
                            )
            
            Stripe::Transfer.create(
              :amount => params[:amount].to_i,
              :currency => "usd",
              :recipient => user_recipient.id,
              :statement_descriptor => "Withdraw for #{@user.email}"
            )
          rescue Stripe::CardError => e
            # The card has been declined
            body = e.json_body
            err  = body[:error]
            render json: { msg: "Failed to charge, #{err[:message]}"}, status: 406 and return
          rescue Stripe::APIConnectionError => e
            # Network communication with Stripe failed
            render json: { msg: "The payment system is not avaiable at this time."}, status: 500 and return
          rescue Stripe::InvalidRequestError => e
            body = e.json_body
            err  = body[:error]
            render json: { msg: "#{err[:message]}"}, status: 406 and return
          end
          
          @user.balance -= params[:amount]
          @user.save
          render json: {}, status: 200
      else
          render json: { msg: "Your balance is insufficient." }, status: 402
      end
  end
  
  private
  
  # Make sure this request comes from valid user
  def get_user
    params.require(:token)
    params.require(:id)
    @user = User.where("id = ? AND session_token = ?", params[:id], params[:token]).first
    if @user.blank?
      render json: { msg: "Account doesn't exist." }, status: 401
    end
  end
end

