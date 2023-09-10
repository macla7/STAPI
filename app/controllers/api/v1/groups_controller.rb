class Api::V1::GroupsController < ApiController
  before_action :set_group, only: %i[ show edit update destroy ]

  def index
    @groups = Group.all
    render json: @groups
  end

  # GET /otherGroups or /otherGroups.json
  def other_groups
    render json: Group.get_data_for_array(current_user.available_groups.includes(:memberships))
  end

  # GET '/myGroups'
  def my_groups
    render json: Group.get_data_for_array(current_user.current_groups.includes(:memberships))
  end

  # GET /groups/1 or /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups or /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        # create associated membership
        @membership = current_user.memberships.create(group_id: @group.id, status: 0, role: 0)

        format.json { render json: Group.get_data_for_array(current_user.current_groups.includes(:memberships)) }
        #format.json { render :show, status: :created, location: @group }
      else
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.json { render :show, status: :ok, location: @group }
      else
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    @group.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params.require(:group).permit(:name)
    end
end
