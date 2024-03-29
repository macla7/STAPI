class Api::V1::MembershipsController < ApiController
  before_action :set_membership, only: %i[ show edit update destroy ]

  # GET /memberships or /memberships.json
  def index
    set_group
    render json: Membership.get_data_for_array(@group.memberships.is_active.includes(:user).joins(:user).order('users.name ASC'))
  end

  # GET /memberships/1 or /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships or /memberships.json
  def create
    set_group
    @membership = Membership.new(membership_params)

    respond_to do |format|
      if @membership.save
        format.json { render json: Membership.get_data_for_array(@group.memberships.is_active.includes(:user).joins(:user).order('users.name ASC'))}
      else
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1 or /memberships/1.json
  def update
    set_group
    respond_to do |format|
      if @membership.update(membership_params)
        format.json { render json: Membership.get_data_for_array(
          @group.memberships.is_active.includes(:user).joins(:user).order('users.name ASC')
          )}
      else
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1 or /memberships/1.json
  def destroy
    @membership.destroy

    respond_to do |format|
      format.html { redirect_to memberships_url, notice: "Membership was successfully destroyed." }
      format.json { render json: Membership.all, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    def set_group
      @group = Group.find(params[:group_id])
    end
    
    # Only allow a list of trusted parameters through.
    def membership_params
      params.require(:membership).permit(:id, :group_id, :user_id, :role, :status)
    end
end
