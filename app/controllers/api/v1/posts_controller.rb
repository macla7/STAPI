class Api::V1::PostsController < ApiController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /groups/${groupId}/posts or /groups/${groupId}/posts.json
  def index
    set_group
    render json: Post.get_data_for_array(@group.posts.live_posts.includes(:bids, :likes, :shifts))
  end

  def index_home
    @posts = Post.joins(group: :memberships).where('memberships.user_id = ? AND memberships.status = ? AND (posts.hide = ? OR posts.hide IS NULL)', current_user.id, 0, false)

    render json: Post.get_data_for_array(@posts.includes(:bids, :likes, :shifts))
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
    @post = current_user.posts.new(post_params)

    # After creating a post, I want to make appropriate notification blueprints..
    # I then want to enque the 'send_notification_thingo' at whenever necessary

    respond_to do |format|
      if @post.save!
        if @post.ends_at_more_than_a_day_away?

          @notification_blueprint = NotificationBlueprint.create(
            notificationable_type: 'Post',
            notificationable_id: @post.id,
            notification_type: 14,
          )
          p 'ABOUTA SEND JOB'
          # Schedule the job to send the notification one day before the end
          # SendNotificationBeforeEndJob.perform_at(@post.ends_at - 1.day, @notification_blueprint.id, current_user.id)
          SendNotificationBeforeEndJob.set(wait_until: @post.ends_at - 1.day).perform_later(@notification_blueprint.id, current_user.id)
        end
        format.json { render json: @post.data, status: :ok }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    @posts = Post.joins(group: :memberships).where('memberships.user_id = ? AND memberships.status = ? AND (posts.hide = ? OR posts.hide IS NULL)', current_user.id, 0, false)
    respond_to do |format|
      if @post.update(post_params)
        format.json { render json: Post.get_data_for_array(@posts.includes(:bids, :likes, :shifts)), status: :ok }
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
        :body, :ends_at, :group_id, :reserve, :hide,
        shifts_attributes: [:position, :start, :end]
      )
    end
end
