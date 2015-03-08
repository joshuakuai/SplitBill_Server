require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest  
  def setup
    @user = FactoryGirl.create(:user)
  end
  
  # Sign up related
  test "Sign up with invalid email" do
    post_request('/users/sign_up', {email: "bademail", password: "asdas"})
    assert_response 401, "Should return 401 to indicate sign up failure"
    assert_equal "Invalid request or email has been registered.", check_response_string, "Didn't give error message."
  end
  
  test "Sign up without password" do
    post_request('/users/sign_up', {email: "bearworldbrave@gmail.com", password: ""})
    assert_response 401, "Should return 401 to indicate sign up failure"
    assert_equal "Invalid request or email has been registered.", check_response_string, "Didn't give error message."
  end
  
  test "Sign up with valid email" do
    post_request('/users/sign_up', {email: "testmail@gmail.com", password: "123456"})
    assert_response 200, "Should return 200 to indicate sign up success"
    assert_not_nil JSON.parse(@response.body)['id'], "Sign up response should contain ID"
    assert_not_nil JSON.parse(@response.body)['token'], "Sign up response should contain token"
    assert_not_nil JSON.parse(@response.body)['balance'], "Sign up response should contain balance"
  end
  
  test "Sign up twice" do
    post_request('/users/sign_up', {email: @user.email, password: @user.password})
    assert_response 401, "Should return 401 to indicate sign up failure"
    assert_equal "Invalid request or email has been registered.", check_response_string, "Didn't give error message."
  end
  
  # Login related
  test "Login with invalid email" do
    post_request('/users/login', {email: "bademail", password: "asdasd", login_type: 1})
    assert_response 401, "Should return 401 to indicate login failure"
    assert_equal "Wrong email and password combination.", check_response_string, "Didn't give error message."
  end
  
  test "Login with invalid login type" do
    post_request('/users/login', {email: "bademail", password: "asdasd", login_type: 17})
    assert_response 401, "Should return 401 to indicate invalid login type"
    assert_equal "Invalid login type.", check_response_string, "Didn't give error message."
  end
  
  test "Login with valid email" do
    post_request('/users/login', {email: @user.email, password: @user.password, login_type: 1})
    assert_response 200, "Should return 200 to indicate login success"
    assert_not_nil JSON.parse(@response.body)['id'], "Login response should contain ID"
    assert_not_nil JSON.parse(@response.body)['token'], "Login response should contain token"
    assert_not_nil JSON.parse(@response.body)['balance'], "Login response should contain balance"
  end
  
  # Forget Password related
  test "Forget password with invalid email" do 
    post_request('/users/forget_password', {email: "bearworldbrave"})
    assert_response 401, "Should return 401 for nonexsit account."
    assert_equal "Email doesn't exist.", check_response_string, "Didn't give error message."
  end
end
