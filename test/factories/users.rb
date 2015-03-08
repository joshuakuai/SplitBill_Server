FactoryGirl.define do 
  factory :user do
    id 1
    email "bearworldbrave@gmail.com"
    password "123456"
    session_token "texttoken"
    balance 100
    
    factory :invalid_email_user do
      id 2
      email "asdasdjklsdajkl"
    end
    
    factory :empty_password_user do
      id 3
      password nil
    end
    
    factory :empty_authen_code_user do
      id 4
      session_token nil
    end
    
    factory :negative_balance_user do
      id 5
      balance -100
    end
    
    factory :transfer_target_user do
      id 6
      email "transfer@gmail.com"
    end
  end
end