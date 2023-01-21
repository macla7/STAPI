class Api::V1::NotificationsController < ApiController
  before_action :set_notification, only: %i[ show edit update destroy ]

  # GET /notifications or /notifications.json
  def index
    notifications = []
    current_user.notifications.includes(notification_blueprint: :notification_origin).each do |notification|
      notifications.push(notification.notification_info)
    end
    render json: notifications
  end

  # GET /notifications/1 or /notifications/1.json
  def show
    respond_to do |format|
      format.json { render json: @notification, status: :ok }
    end
  end

  # GET /notifications/new
  def new
    @notification = Notification.new
  end

  # GET /notifications/1/edit
  def edit
  end

  # POST /notifications or /notifications.json
  def create
    @notification = Notification.new(notification_params)

    respond_to do |format|
      if @notification.save
        # create associated membership
        @membership = current_user.memberships.create(notification_id: @notification.id, status: 0, role: 0)
        format.json { render json: Notification.all, status: :ok }
        #format.json { render :show, status: :created, location: @notification }
      else
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notifications/1 or /notifications/1.json
  def update
    respond_to do |format|
      if @notification.update(notification_params)
        # format.json { render :show, status: :ok, location: @notification }
        notifications = []
        current_user.notifications.includes(notification_blueprint: :notification_origin).each do |notification|
          notifications.push(notification.notification_info)
        end
        format.json { render json: notifications, status: :ok }
      else
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1 or /notifications/1.json
  def destroy
    @notification.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def notification_params
      params.require(:notification).permit(:id, :actioned)
    end
end
