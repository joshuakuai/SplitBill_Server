class User < ActiveRecord::Base
  has_many :authen_codes
  def change_balance
      params.permit(:amount)
      @balance+=params[:amount]
  end
end
