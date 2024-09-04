class FundraisersController < ApplicationController
  before_action :set_fundraiser, only: %i[ show edit update destroy ]

  # GET /fundraisers or /fundraisers.json
  def index
    @fundraisers = Fundraiser.where(masjid_id: current_masjid.id)
  end

  # GET /fundraisers/1 or /fundraisers/1.json
  def show
    @donation = Donation.new
    @donations = Donation.where(fundraiser_id: @fundraiser.id)
  end

  # GET /fundraisers/new
  def new
    @fundraiser = Fundraiser.new
  end

  # GET /fundraisers/1/edit
  def edit
  end

  # POST /fundraisers or /fundraisers.json
  def create
    @fundraiser = Fundraiser.new(fundraiser_params)
    @fundraiser.masjid_id = current_masjid.id


    respond_to do |format|
      if @fundraiser.save
        format.html { redirect_to fundraiser_url(@fundraiser), notice: "Fundraiser was successfully created." }
        format.json { render :show, status: :created, location: @fundraiser }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fundraiser.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fundraisers/1 or /fundraisers/1.json
  def update
    respond_to do |format|
      if @fundraiser.update(fundraiser_params)
        format.html { redirect_to fundraiser_url(@fundraiser), notice: "Fundraiser was successfully updated." }
        format.json { render :show, status: :ok, location: @fundraiser }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fundraiser.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fundraisers/1 or /fundraisers/1.json
  def destroy
    @fundraiser.destroy

    respond_to do |format|
      format.html { redirect_to fundraisers_url, notice: "Fundraiser was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fundraiser
      @fundraiser = Fundraiser.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def fundraiser_params
      params.require(:fundraiser).permit(:name, :description, :goal_amount, :masjid_id, :end_date)
    end
end
