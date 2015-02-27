require 'encrypt_helper'

class UsersController < ApplicationController
  include EncryptHelper
  
  rescue_from ActionController::ParameterMissing do
    render :msg => "Invalid Request.", :status => 400
  end
  
  # POST /login
  def login
    # Check params
    params.permit(:password, :login_type, :email)
    
    # Set up the result
    result = Hash.new
  
    # Check Login type
    case params[:login_type]
    when 1
      # Normal Login, check email and password
      user = User.where(email: params[:email]).first
      
    when 2
      # Decrypt the email
      user = User.where(email: decrypt(params[:email])).first
    end
    
    if user
      if user.password == params[:password]
        result["id"] = user.id
        result["token"] = user.session_token
      else
        result["msg"] = "Your email address is not a vailid account."
      end
    else
      result["msg"] = "Your email address is not a vailid account."
    end
  
    render json: result
  end
  
  # POST /forget_password
  def forget_password
    
  end
  
  # POST /sign_up
def sign_up
    # Check params
    params.permit(:password, :sign_up_type, ;email)
    # Set up the result
    result = Hash.new
    # Check sign_up_type
    case params[:sign_up_type]
        when 1
        if puts [paras[:password]].blank?
            # check the password
            render :msg => "Invalid request.", :status =>400
            when 2
            
        end
        # check the email
        if puts [params[email]].blank?
            render :msg => "Invalid request.", :status =>400
            # check if the account already exist
            user2=User.where(email: params[:email]).first
            if user2
                if puts not([user2.password].blank?)
                    render :msg => "Account has already existed.", :status =>401
                end
            end
            # create user
            User.create(params[email],params[password])
            
            
            # 根据email和创建时间获取token 这里不太会写
            user=User.where(email: params[:email]).first
            token=encrypt(params[email]＋user.created_at.to_s)
            # update the session_token by method'update_attributes'
            User.where(email: params[:email]).first.update_attributes(:session_token=>token)
            result["id"]=user.idUser
            result["token"]=token
            # result["id"] = 5
            # result["token"] = "asdasdasdas"
            
            render json: result
        end
end
