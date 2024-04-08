class AdminMailer < ApplicationMailer
  default from: 'notifications@example.com'
  default template_path: 'admin/mailer'

  def welcome_email
    @user = params[:user]
    @password = params[:password]
    mail(to: @user.email, subject: 'Welcome to Stock App')
  end
end
