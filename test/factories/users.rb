FactoryGirl.define do 
  factory :user do
    id 2
    email "bearworldbrave@gmail.com"
    password "123456"
    session_token "texttoken"
    balance 100
    
    factory :invalid_email_user do
      id 3
      email "asdasdjklsdajkl"
    end
    
    factory :empty_password_user do
      id 4
      password nil
    end
    
    factory :empty_authen_code_user do
      id 5
      session_token nil
    end
    
    factory :negative_balance_user do
      id 6
      balance -100
    end
    
    factory :transfer_target_user do
      id 7
      email "transfer@gmail.com"
    end
  end
end