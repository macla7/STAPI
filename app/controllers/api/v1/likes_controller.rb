class Api::V1::LikesController < ApiController
  before_action :set_like, only: %i[ show edit update destroy ]

  # GET /likes or /likes.json
  def index
    set_post
    @likes = Like.all
    render json: @post.likes
  end

  # GET /likes/1 or /likes/1.json
  def show

  end

  # GET /likes/new
  def new
    @like = Like.new
  end

  # GET /likes/1/edit
  def edit
  end

  # POST /likes or /likes.json
  def create
    set_post_with_like
    @like = current_user.likes.new(like_params)

    respond_to do |format|
      if @like.save
        broadcast @post
        format.json { render json: @post.likes, status: :ok }
      else
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /likes/1 or /likes/1.json
  def update
    respond_to do |format|
      if @like.update(like_params)
        format.json { render json: @like, status: :ok, location: @like }
      else
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /likes/1 or /likes/1.json
  def destroy
    set_post_with_like
    @like.destroy

    respond_to do |format|
      broadcast @post
      format.json { render json: @post.likes, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_like
      @like = Like.where("user_id = ? AND post_id = ?", params[:like][:user_id], params[:like][:post_id]).first
    end

    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_post_with_like
      @post = Post.find(params[:like][:post_id])
    end

    # Only allow a list of trusted parameters through.
    def like_params
      params.require(:like).permit(:user_id, :post_id)
    end

    def broadcast post
      PostsChannel.broadcast_to(post, { type: 'Likes', body: post.likes })
    end
end
