class Api::V1::PostsController < ApiController
  before_action :set_post, only: %i[ show edit update destroy ]
  skip_before_action :doorkeeper_authorize!, only: %i[show]

  # GET /groups/${groupId}/posts or /groups/${groupId}/posts.json
  def index
    set_group
    render json: Post.get_data_for_array(@group.posts.live_posts.includes(:bids, :likes, :shift))
  end

  def index_home
    @posts = Post.joins(group: :memberships).where('memberships.user_id = ? AND memberships.status = ? AND (posts.hide = ? OR posts.hide IS NULL)', current_user.id, 0, false)

    render json: Post.get_data_for_array(@posts.includes(:bids, :likes, :shift))
  end

  # GET /posts/1 or /posts/1.json
  def show
    render json: @post.data
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
    ActiveRecord::Base.transaction do
      p 'creating temporary group ............................... !!!'
      @group = Group.create()
      p 'creating admin ............................... !!!'
      @group.memberships.create(
        user_id: current_user.id,
        role: 0,
        status: 0
      )
      
      p 'creating memberships ............................... !!!'
      params[:members_attributes].each do |user_id|
        p 'creating membership for user ' + user_id.to_s
        @group.memberships.create(
        user_id: user_id,
        role: 1,
        status: 0
        )
      end

      @post = current_user.posts.new(post_params)
      @post.group = @group

      respond_to do |format|
        if @post.save!
          notification_service = NotificationService.new(@post, current_user)
          # notification_service.create_and_schedule_notifications

          format.json { render json: @post.data, status: :ok }
        else
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    @posts = Post.joins(group: :memberships).where('memberships.user_id = ? AND memberships.status = ? AND (posts.hide = ? OR posts.hide IS NULL)', current_user.id, 0, false)
    respond_to do |format|
      if @post.update(post_params)
        format.json { render json: Post.get_data_for_array(@posts.includes(:bids, :likes, :shift)), status: :ok }
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
        :body, :ends_at, :hide, :solution,
        shift_attributes: [:description, :start, :end, :position, :user_id]
      )
    end
end
