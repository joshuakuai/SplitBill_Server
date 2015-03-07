require 'encrypt_helper'
require 'authen_code_helper'
require 'digest/md5'

class UsersController < ApplicationController
  include EncryptHelper
  include AuthenCodeHelper
  
  rescue_from ActionController::ParameterMissing do
    render json: { :msg => "Invalid Request."}, :status => 400
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
      if !sign_up_helper(decrypted_email, 2)
        render json: { msg: "Invalid social login request."}, status: 401
        return
      end
      user = User.where(email: decrypted_email).first
    else
      render json: { msg: "Invalid login type."}, status: 401
      return
    end
    
    if user && (user.password == params[:password])
      result[:id] = user.id
      result[:token] = user.session_token
      render json: result, status: 200
    else
      result[:msg] = "Wrong email and password combination."
      render json: result, status: 401
    end
  end
  
  # POST /forget_password
  def forget_password
    # Check params
    params.permit(:email).require(:email)
    
    # Check if user exist
    user = User.where(email: params[:email]).first
    
    if user
      create_authen_code(user, 1)
      render :json => {}, status: 200
    else
      render json: {
        msg: "Email doesn't exist."
      }, status: 401
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
        render json: { msg: "Wrong code" }, status: 401
      end
    else
      render json: { msg: "Email doesn't exist." }, status: 401
    end
    
  end
  
  # POST /sign_up
  def sign_up
      # Check params
      params.permit(:password, :email)
      
      if sign_up_helper(params[:email], 1, params[:password])
        # Search this user again
        user = User.where(email: params[:email]).first
        render json: {id: user.id, token: user.session_token}, status: 200
      else
        render json: { msg: "Invalid request or email has been registered." }, status: 401
      end
  end
  
  private
  def sign_up_helper(email, sign_up_type, password = "")
    # check if the account already exist
    user = User.where(email: params[:email]).first
    
    if user
      case sign_up_type
      when 1
        # Return false if
        # User wants to register an account which has already been set a password
        return false
      when 2
        # Return true immediately if 
        # User are trying to register an social account that has been registered before
        return true
      end
    else
      if sign_up_type == 1 && password.blank?
        # User wants to register an password-based account without submitting a password
        return false
      end
    end
    
    # New user, begin sign up process
    # create user
    user = User.where(email: email).first_or_initialize do |new_user|
      new_user.password = password
      # Create the token by combining user email and create time
      new_user.session_token = Digest::MD5.hexdigest("#{email}#{new_user.created_at.to_s}")
      new_user.balance=0
      new_user.save
    end
    
    user.valid?
  end
end
