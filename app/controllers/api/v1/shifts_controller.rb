class Api::V1::ShiftsController < ApiController
  before_action :set_shift, only: %i[ show edit update destroy ]

  # GET /shifts or /shifts.json
  def index
    set_post
    @shifts = Shift.all
    render json: @post.shifts
  end

  # GET /shifts/1 or /shifts/1.json
  def show

  end

  # GET /shifts/new
  def new
    @shift = Shift.new
  end

  # GET /shifts/1/edit
  def edit
  end

  # POST /shifts or /shifts.json
  def create
    set_post_with_shift
    @shift = current_user.shifts.new(shift_params)

    respond_to do |format|
      if @shift.save
        format.json { render json: @post.shifts, status: :ok }
      else
        format.json { render json: @shift.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shifts/1 or /shifts/1.json
  def update
    respond_to do |format|
      if @shift.update(shift_params)
        format.json { render json: @shift, status: :ok, location: @shift }
      else
        format.json { render json: @shift.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shifts/1 or /shifts/1.json
  def destroy
    @shift.destroy

    respond_to do |format|
      format.json { render json: Shift.all, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shift
      @shift = Shift.where("user_id = ? AND post_id = ?", params[:shift][:user_id], params[:shift][:post_id]).first
    end

    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_post_with_shift
      @post = Post.find(params[:shift][:post_id])
    end

    # Only allow a list of trusted parameters through.
    def shift_params
      params.require(:shift).permit(:user_id, :post_id, :price)
    end
end
