require 'test_helper'

class BalanceTest < ActionDispatch::IntegrationTest
  def setup
    @user = FactoryGirl.create(:user)
    @transfer_target_user = FactoryGirl.create(:transfer_target_user)
    
    @card_token = Stripe::Token.create(
    :card => {
    :number => "4000000000000077",
    :exp_month => 3,
    :exp_year => 2016,
    :cvc => "314"}).id
    
    @bank_account_token = Stripe::Token.create(
    :bank_account => {
    :country => "US",
    :routing_number => "110000000",
    :account_number => "000123456789",
    }).id
  end
  
  test "Valid stripe token for deposit" do
    post_request('/balance/deposit', valid_user_request_with({stripe_token: @card_token, amount: 1000}))
    assert_response 200, "Didn't return 200. #{check_response_string}"
  end
  
  test "Invalid stripe token for deposit" do
    post_request('/balance/deposit', valid_user_request_with({stripe_token: 'asdadsadasdas', amount: 1000}))
    assert_response 406, "Invalid token cound't be charged."
  end
  
  test "Valid transfer amount" do
    post_request('/balance/transfer', valid_user_request_with({target_user: @transfer_target_user.email, amount: @user.balance}))
    assert_response 200, "Didn't return 200. #{check_response_string}"
  end
  
  test "Invalid transfer amount" do
    post_request('/balance/transfer', valid_user_request_with({target_user: @transfer_target_user.email, amount: @user.balance+200}))
    assert_response 402, "Didn't return 402. #{check_response_string}"
  end
  
  test "Invalid transfer target" do
    post_request('/balance/transfer', valid_user_request_with({target_user: "bad_target_email@gmail.com", amount: @user.balance}))
    assert_response 406, "Didn't return 406. #{check_response_string}"
  end
  
  test "Valid withdraw amount" do
    post_request('/balance/withdraw', valid_user_request_with({full_name: 'John Test', 
                                                               amount: @user.balance/2,
                                                               stripe_token: @bank_account_token}))
    assert_response 200, "Didn't return 200. #{check_response_string}"
  end
  
  test "invalid withdraw amount" do
    post_request('/balance/withdraw', valid_user_request_with({full_name: 'John Test', 
                                                               amount: @user.balance*2,
                                                               stripe_token: @bank_account_token}))
    assert_response 402, "Didn't return 402. #{check_response_string}"
  end
end
