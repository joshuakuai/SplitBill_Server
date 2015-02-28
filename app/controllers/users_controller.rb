require 'encrypt_helper'
require 'authen_code_helper'

class UsersController < ApplicationController
  include EncryptHelper
  include AuthenCodeHelper
  
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
    
    if user && user.password == params[:password]
      result["id"] = user.id
      result["token"] = user.session_token
    else
      result["msg"] = "Wrong Email and password combination."
    end
  
    render json: result
  end
  
  # POST /forget_password
  def forget_password
    # Check params
    params.permit(:email).require(:email)
    
    # Check if user exist
    user = User.where(email: params[:email]).first
    
    if user
      create_authen_code(user, 1)
      render :json => {}
    else
      render :json => {:msg => "Email doesn't exist."}
    end
  end
  
  # POST /reset_password
  def reset_password
    # Check params
    params.permit(:email, :code, :new_password)
    
    # Check if user exist
    user = User.where(email: params[:email]).first
    
    if user
      # Verify code
      if verify_authen_code(user, params[:code], 1)
        # Reset the password
        user.update(password: params[:new_password])
        render :json => {}
      else
        # Wrong code
        render :json => {:msg => "Wrong code."}
      end
    else
      render :json => {:msg => "Email doesn't exist."}
    end
    
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
