class UserMailer < ActionMailer::Base
  default from: "no-reply@splitbill.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.forget_password.subject
  #
  def forget_password(user, code)
    @code = code
    mail(to: user.email, subject: '[Split Bill] Forget Password')
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
