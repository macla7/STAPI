class Api::V1::PostsController < ApiController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    set_group
    postWithAssociations = []

    @group.posts.active.includes(:bids, :likes, :shifts).each do |post|
      postWithAssociations.push(post.post_info)
    end
    
    render json: postWithAssociations
  end

  def index_home
    @posts = Post.joins(group: :memberships).where('memberships.user_id = ?', current_user.id)

    postWithAssociations = []
    @posts.active.includes(:bids, :likes, :shifts).each do |post|
      postWithAssociations.push(post.post_info)
    end
    render json: postWithAssociations
  end

  # GET /posts/1 or /posts/1.json
  def show
    render json: @post.post_info
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.new(post_params)
    p current_user
    p 'bing'
    p @post
    respond_to do |format|
      if @post.save!
        format.json { render json: @post.post_info, status: :ok }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.json { render json: @post, status: :ok, location: @post }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { render json: Post.all, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def set_group
      @group = Group.find(params[:group_id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(
        :body, :ends_at, :group_id, :reserve,
        shifts_attributes: [:position, :start, :end]
      )
    end
end
