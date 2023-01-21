class PostsChannel < ApplicationCable::Channel
  include ActiveModel::Serializers::JSON
  def subscribed
    stop_all_streams
    post = Post.find(params[:post])
    stream_for post
  end

  def unsubscribed
    stop_all_streams
  end
end
