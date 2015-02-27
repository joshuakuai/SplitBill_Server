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
    result = Hash.new
    result["id"] = 5
    result["token"] = "asdasdasdas"
    
    render json: result
  end
end
