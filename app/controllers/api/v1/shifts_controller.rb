class Api::V1::ShiftsController < ApiController
  before_action :set_shift, only: %i[ update destroy ]

  # GET /shifts or /shifts.json
  def index
    set_user
    render json: @user.shifts
  end

  def for_month
    user_id = params[:id]
    month = params[:month]

    # Validate user_id and month parameters if needed

    start_date = Time.strptime(month, "%Y-%m")
    end_date = start_date.end_of_month

    shifts = Shift.where(user_id: user_id, start: start_date..end_date)
    
    render json: shifts
  end

  # # GET /shifts/1 or /shifts/1.json
  # def show
  # end

  # GET /shifts/new
  def new
    @shift = Shift.new
  end

  # GET /shifts/1/edit
  def edit
  end

  # POST /shifts or /shifts.json
  def create
    @shift = current_user.shifts.new(shift_params)

    respond_to do |format|
      if @shift.save
        format.json { render json: @shift, status: :ok }
      else
        format.json { render json: @shift.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shifts/1 or /shifts/1.json
  def update
    respond_to do |format|
      if @shift.update(shift_params)
        format.json { render json: @shift, status: :ok }
      else
        format.json { render json: @shift.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shifts/1 or /shifts/1.json
  def destroy
    @shift.destroy

    respond_to do |format|
      format.json { render json: [], status: :ok }
    end
  end

  private
    # # Use callbacks to share common setup or constraints between actions.
    # def set_shift
    #   @shift = Shift.where("user_id = ? AND post_id = ?", params[:shift][:user_id], params[:shift][:post_id]).first
    # end

    def set_shift
      @shift = Shift.find(params[:id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    # Only allow a list of trusted parameters through.
    def shift_params
      params.require(:shift).permit(:user_id, :description, :position, :end, :start)
    end
end
