class Api::V1::InvitesController < ApiController
  before_action :set_invite, only: %i[ show edit update destroy update_request]

  # GET /invites or /invites.json
  def index
    @invites = Invite.all
    render json: @invites
  end

  def index_requests
    set_group
    render json: @group.requests.not_accepted
  end

  # GET /invites/1 or /invites/1.json
  def show
  end

  # GET /invites/new
  def new
    @invite = Invite.new
  end

  # GET /invites/1/edit
  def edit
  end

  # POST /invites or /invites.json
  def create
    @invite = Invite.new(invite_params)

    respond_to do |format|
      if @invite.save
        format.json { render json: @invite, status: :ok }
      else
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invites/1 or /invites/1.json
  def update
    respond_to do |format|
      if @invite.update(invite_params)
        format.json { render json: Invite.all, status: :ok }
      else
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_request
    set_group
    respond_to do |format|
      if @invite.update(invite_params)
        format.json { render json: @group.requests.not_accepted, status: :ok }
      else
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /invites/1 or /invites/1.json
  def destroy
    @invite.destroy

    respond_to do |format|
      format.html { redirect_to invites_url, notice: "Invite was successfully destroyed." }
      format.json { render json: Invite.all, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invite
      @invite = Invite.find(params[:id])
    end

    def set_group
      @group = Group.find(params[:group_id])
    end

    # Only allow a list of trusted parameters through.
    def invite_params
      params.require(:invite).permit(:group_id, :internal_user_id, :external_user_id, :request, :accepted)
    end
end
