class UserMailer < Devise::Mailer
  # This was created in case I wanted to customise the 'change_password'
  # email sent by devise. According to this guide: 
  # https://www.truemark.dev/blog/reset-password-in-react-and-rails/

  default from: "<bobbbybing@hello.com>"

  def reset_password_instructions(record, token, opts={})
    super
  end

end
