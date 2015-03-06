require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "User email validation" do
    user = FactoryGirl.build(:invalid_email_user)
    assert user.invalid?, "User email must be valid structure."
  end
  
  test "User email should be unique" do
    FactoryGirl.create(:user)
    assert_raise ActiveRecord::RecordInvalid do
      FactoryGirl.create(:user)
    end
  end
  
  test "User token should not be empty" do
    user = FactoryGirl.build(:empty_authen_code_user)
    assert user.invalid?, "User authen token couldn't be nil"
  end
  
  test "User password could be empty with valid email" do
    user = FactoryGirl.build(:empty_password_user)
    assert user.valid?, "User password could be empty."
  end
end
