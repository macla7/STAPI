class Api::V1::BidsController < ApiController
  before_action :set_bid, only: %i[ show edit update destroy ]

  # GET /bids or /bids.json
  def index
    set_post
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

  # PATCH/PUT /bids or /bids.json
  # def update
  #  respond_to do |format|
  #    if @bid.update(bid_params)
  #      format.json { render json: @bid, status: :ok, location: @bid }
  #    else
  #      format.json { render json: @bid.errors, status: :unprocessable_entity }
  #    end
  #  end
  # end

  # DELETE /bids/1 or /bids/1.json
  # def destroy
  #   @bid.destroy

  #   respond_to do |format|
  #     format.json { render json: Bid.all, status: :ok }
  #   end
  # end

  # POST /bids/bulk_update or /bids/bulk_update.json
  def bulk_update
    set_post
    # Assuming the array of objects with 'approved' and 'id' properties is passed in the params as 'bids_to_update'
    bids_to_update = params[:updated_bids]

    # Create a hash with 'id' as the key and 'approved' as the value from the 'bids_to_update' array
    bids_data = bids_to_update.each_with_object({}) { |bid, hash| hash[bid['id'].to_i] = ActiveRecord::Type::Boolean.new.cast(bid['approved']) }

    # Find the bids that need to be updated based on their IDs
    bids = Bid.where(id: bids_data.keys)

    # Update the 'approved' property for each bid based on the data in 'bids_data'
    bids.each do |bid|
      bid.update(approved: bids_data[bid.id])
    end

    # Return the updated bids as a response
    render json: @post.data, status: :ok
  end



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
      params.require(:bid).permit(:user_id, :post_id)
    end

    def broadcast post
      PostsChannel.broadcast_to(post, { type: 'Bids', body: post.bids_with_avatars })
    end
end
