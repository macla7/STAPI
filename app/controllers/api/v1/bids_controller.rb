class Api::V1::BidsController < ApiController
  before_action :set_bid, only: %i[ show edit update destroy ]

  # GET /bids or /bids.json
  def index
    set_post
    @bids = Bid.all
    render json: @post.bids
  end

  # GET /bids/1 or /bids/1.json
  def show
  end

  # GET /bids/new
  # def new
  #   @bid = Bid.new
  # end

  # GET /bids/1/edit
  # def edit
  # end

  # POST /bids or /bids.json
  def create
    set_post_with_bid
    @bid = current_user.bids.new(bid_params)

    respond_to do |format|
      if @bid.save
        broadcast @post
        format.json { render json: @post.bids, status: :ok }
      else
        format.json { render json: @bid.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bids/1 or /bids/1.json
  # def update
  #   respond_to do |format|
  #     if @bid.update(bid_params)
  #       format.json { render json: @bid, status: :ok, location: @bid }
  #     else
  #       format.json { render json: @bid.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /bids/1 or /bids/1.json
  # def destroy
  #   @bid.destroy

  #   respond_to do |format|
  #     format.json { render json: Bid.all, status: :ok }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bid
      @bid = Bid.where("user_id = ? AND post_id = ?", params[:bid][:user_id], params[:bid][:post_id]).first
    end

    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_post_with_bid
      @post = Post.find(params[:bid][:post_id])
    end

    # Only allow a list of trusted parameters through.
    def bid_params
      params.require(:bid).permit(:user_id, :post_id, :price)
    end

    def broadcast post
      PostsChannel.broadcast_to(post, { type: 'Bids', body: post.bids_with_avatars })
    end
end
