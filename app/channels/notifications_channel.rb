class NotificationsChannel < ApplicationCable::Channel
  include ActiveModel::Serializers::JSON
  def subscribed
    stop_all_streams
    user = User.find(params[:user])
    stream_for user
  end

  def unsubscribed
    stop_all_streams
  end
end
