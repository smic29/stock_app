class AdminMailer < ApplicationMailer
  default from: ENV['EMAIL_ADDRESS']
  default template_path: 'admin/mailer'

  def welcome_email
    @user = params[:user]
    @password = params[:password]
    mail(to: @user.email, subject: 'Welcome to Stock App')
  end

  def trade_approved_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Your Trading Access Has Been Approved!')
  end
end
