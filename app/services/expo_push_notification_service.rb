require 'exponent-server-sdk'

class ExpoPushNotificationService
  def initialize(user)
    @user = user
  end

  def send_notifications(message)
    messages = []
    @user.push_tokens.each do |token|
      messages.push({
      to: token.push_token,
      sound: "default",
      body: message
      })
    end

    client = Exponent::Push::Client.new
    handler = client.send_messages(messages)

    # Handle the response, check for errors, etc.
    # According to 'exponent-server-sdk'
      # # you probably want to delay calling this because the service might take a few moments to send
      # # I would recommend reading the expo documentation regarding delivery delays
    # TODO: Need to investigate this further. Not a priority atm.

    # if client.verify_deliveries(handler.receipt_ids)
    #   puts 'Push notification sent successfully'
    # else
    #   puts 'Failed to send push notification'
    # end

  end
end