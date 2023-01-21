class Api::V1::CommentsController < ApiController
  before_action :set_comment, only: %i[ show edit update destroy ]

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
    render json: @comments
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  # def new
  #   @comment = Comment.new
  # end

  # GET /comments/1/edit
  # def edit
  # end

  # POST /comments or /comments.json
  def create
    p 'TRYING TO MAKE A COMMENT!!!'
    set_post_with_comment
    @comment = current_user.comments.new(comment_params)

    respond_to do |format|
      if @comment.save
        p 'TRYING TO MAKE A COMMENT!!!!!!'
        broadcast @post
        format.json { render json: @post.comments, status: :ok }
      else
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  # def update
  #   respond_to do |format|
  #     if @comment.update(comment_params)
  #       format.json { render json: @comment, status: :ok, location: @comment }
  #     else
  #       format.json { render json: @comment.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /comments/1 or /comments/1.json
  # def destroy
  #   @comment.destroy

  #   respond_to do |format|
  #     format.json { render json: Comment.all, status: :ok }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.where("user_id = ? AND post_id = ?", params[:comment][:user_id], params[:comment][:post_id]).first
    end

    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_post_with_comment
      p 'is it getting hereeeeeeee'
      @post = Post.find(params[:comment][:post_id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:user_id, :post_id, :body)
    end

    def broadcast post
      PostsChannel.broadcast_to(post, { type: 'Comments', body: post.comments_with_avatars })
    end
end
