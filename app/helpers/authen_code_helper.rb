module AuthenCodeHelper
  # Code Type
  # 1 => Forget Password
  
  def create_authen_code(user, authen_type)
    # Generate four digits authen code
    o = [(1..9)].map { |i| i.to_a }.flatten
    code = (0...4).map { o[rand(o.length)] }.join
    
    # Save code
    user.authen_codes.where(authen_type: authen_type).first_or_initialize do |authen_code|
      authen_code.code = code
      authen_code.save
    end
    
    # Send email
    UserMailer.forget_password(user, code).deliver
  end
  
  def verify_authen_code(user, code, authen_type)
    authen_code = user.authen_codes.where(authen_type: authen_type).first
    if authen_code && (authen_code.code == code)
      # Clear the code
      authen_code.destroy
      true
    else
      false
    end
  end
end
