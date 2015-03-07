FactoryGirl.define do 
  factory :user do
    email "bearworldbrave@gmail.com"
    password "123456"
    session_token "asdasdowqnqowdnp"
    
    factory :invalid_email_user do
      email "asdasdjklsdajkl"
    end
    
    factory :empty_password_user do
      password nil
    end
    
    factory :empty_authen_code_user do
      session_token nil
    end
  end
end