# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/forget_password
  def forget_password
    UserMailer.forget_password
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/welcome
  def welcome
    UserMailer.welcome
  end

end
