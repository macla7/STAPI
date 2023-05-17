class UserMailer < Devise::Mailer
  # This was created in case I wanted to customise the 'change_password'
  # email sent by devise. According to this guide: 
  # https://www.truemark.dev/blog/reset-password-in-react-and-rails/

  default from: "<do-not-reply@em5371.shiftmarket.com.au>"

  def reset_password_instructions(record, token, opts={})
    super
  end

  # def welcome_email
  #   @user = params[:user]
  #   mail(to: @user.email, subject: 'Welcome To ShiftMarket')
  # end

  def registration_confirmation
    @user = params[:user]
    mail(:to => "#{@user.name} <#{@user.email}>", :subject => "Registration Confirmation")
  end

end
