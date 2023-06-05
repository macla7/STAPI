class Api::V1::PushTokensController < ApiController
  before_action :set_pushToken, only: %i[ show edit update destroy ]

  # GET /push_tokens or /push_tokens.json
  def index
    render json: current_user.push_tokens
  end

  # GET /push_tokens/1 or /push_tokens/1.json
  def show
  end

  # GET /push_tokens/new
  def new
    @pushToken = PushToken.new
  end

  # GET /push_tokens/1/edit
  def edit
  end

  # POST /push_tokens or /push_tokens.json
  def create
    set_user_with_pushToken

    # or should I use @user?
    @pushToken = current_user.push_tokens.new(pushToken_params)

    respond_to do |format|
      if @pushToken.save
        format.json { render json: { currentPushToken: @pushToken, pushTokens: current_user.push_tokens }, status: :ok }
      else
        format.json { render json: @pushToken.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /push_tokens/1 or /push_tokens/1.json
  def update
    set_pushToken

    @pushToken.touch

    respond_to do |format|
      if @pushToken.update(pushToken_params)
        format.json { render json: { currentPushToken: @pushToken, pushTokens: current_user.push_tokens }, status: :ok }
      else
        format.json { render json: @pushToken.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /push_tokens or /push_tokens.json
  def destroy
    set_pushToken

    @pushToken.destroy

    respond_to do |format|
      format.json { render json: current_user.push_tokens, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pushToken
      @pushToken = PushToken.where("id = ?", params[:pushToken][:id]).first
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_user_with_pushToken
      @user = User.find(params[:pushToken][:user_id])
    end

    # Only allow a list of trusted parameters through.
    def pushToken_params
      params.require(:pushToken).permit(:id, :user_id, :device_id, :push_token)
    end

end
