require 'stripe'

class BalanceController < ApplicationController
    rescue_from ActionController::ParameterMissing do
    render :msg => "Invalid Request.", :status => 400
end

#POST /deposite
def deposite
    params.permit(:id, :token, :stripe_token, :amount)
    user=User.where(idUser: params[:id]).first
    
    #check the existance of account
    if user
        user_charge=Stripe::Charge.create(
                              :amount => params[:amount],
                              :currency => "usd",
                              :source => params[:stripe_token]
                              )
        if user_charge
            user.change_balance(params[:amount])
        else
            render json: {
                error: "Invalid stripe token.",
            }, status: 406
        end
    else
        render json: {
            error: "Account doesn't exist.",
        }, status: 401
    end
end

#POST /transfer
def transfer
    params.permit(:id, :token, :target_user, :amount)
    user=User.where(idUser: params[:id]).first
    target_user=User.where(email: params[:target_user]).first
    
    #check the existance of account
    #check the balance
    if user
        if user.balance>=params[:amount]
            if target_user
                target_user.change_balance(amount)
                target_user.save
                user.change_balance(-amount)
                user.save
            else
                render json: {
                    error: "Target account doesn't exist.",
                }, status: 406
            end
        else
            render json: {
                error: "Your balance is insufficient.",
            }, status: 402
        end
    else
        render json: {
            error: "Account doesn't exist.",
        }, status: 401
    end
end

#POST /withdraw
def withdraw
    params.permit(:id, :token, :full_name, :amount, :bank_email, :stripe_token)
    user=User.where(idUser: params[:id]).first
    
    #check the existance of account
    #check the balance
    if user
        if user.balance>=params[:amount]
            user_recipient=Stripe::Recipient.create(
                                                    :name => params[:full_name],
                                                    :type => "individual",
                                                    :card => params[:stripe_token]
                                                    )
            if user_recipient
                user.change_balance(-amount)
            else
                render json: {
                    error: "Invalid stripe token.",
                }, status: 406
            end
        else
            render json: {
                error: "Your balance is insufficient.",
            }, status: 402
        end
    else
        render json: {
            error: "Account doesn't exist.",
        }, status: 401
    end
end