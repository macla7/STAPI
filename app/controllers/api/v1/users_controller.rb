class Api::V1::UsersController < ApiController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    set_group
    @groups_users = @group.users
    @invited_users = @group.invited_users
    @all_users = User.all
    @relevant_users = (@all_users - @groups_users - @invited_users)

    relevant_users_with_details = []
    @relevant_users.each do |user|
      relevant_users_with_details.push(user.user_info)
    end
    render json: relevant_users_with_details
  end

  # GET /users/1 or /users/1.json
  def show
    respond_to do |format|
      format.json { render json: @user.user_info, status: :ok }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    p 'hello from CREAEEETEEE'
    p user_params

    respond_to do |format|
      if @user.save
        format.json { render json: User.all, status: :ok }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    p @user
    p 'HELLLLLOOOO'
    respond_to do |format|
      if @user.update(user_params)
        format.json { render json: @user, status: :ok }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { render json: User.all, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def set_group
      @group = Group.find(params[:group_id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:id, :body, :ends_at, :auction, :group_id, :avatar, :name)
    end
end
