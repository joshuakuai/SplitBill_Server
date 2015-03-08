ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  Stripe.api_key = "sk_test_HjgBPaq7P9RBbtyKejj3wwP7"
  
  def check_response_string
    JSON.parse(@response.body)['msg']
  end
  
  def post_request(path, json_data)
    @request_headers = { "Accept" => "application/json", "Content-Type" => "application/json" }
    post path, json_data.to_json, @request_headers
  end
  
  def valid_user_request_with(data)
    user = FactoryGirl.build(:user)
    data.merge({id: user.id, token: user.session_token})
  end
end
