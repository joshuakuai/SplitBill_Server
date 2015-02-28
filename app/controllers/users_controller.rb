require 'encrypt_helper'
require 'authen_code_helper'
require 'digest/md5'

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
      decrypted_email = decrypt(params[:email])
      sign_up_helper(decrypted_email, 2)
      user = User.where(email: decrypted_email).first
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
      render :msg => "Email doesn't exist.", :status =>401
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
        render :msg => "Wrong code.", :status =>401
      end
    else
      render :msg => "Email doesn't exist.", :status =>401
    end
    
  end
  
  # POST /sign_up
  def sign_up
      # Check params
      params.permit(:password, :email)
      
      if sign_up_helper(params[:email], 1, params[:password])
        # Search this user again
        user = User.where(email: params[:email]).first
        
        # Set up the result
        result = Hash.new
        result["id"] = user.id
        result["token"] = user.session_token
        
        render json: result
      else
        render :msg => "Invalid request or email has been registered.", :status =>400
      end
  end
  
  private
  def sign_up_helper(email, sign_up_type, password = "")
    # check if the account already exist
    user = User.where(email: params[:email]).first
    
    if (sign_up_type == 1 && password.blank?) || (user && user.password)
      # Return false if
      # 1. User wants to register an password-based account without submitting a password
      # 2. User wants to register an account which has already been set a password
      false
    elsif (sign_up_type == 2 && user)
      # Return true immediately if 
      # 1. User are trying to register an social account that has been registered before
      true
    end
    
    # create user
    User.where(email: email).first_or_initialize do |new_user|
      new_user.password = password
      # Create the token by combining user email and create time
      new_user.session_token = Digest::MD5.hexdigest("#{email}#{new_user.created_at.to_s}")
      new_user.save
    end
    
    true
  end
end