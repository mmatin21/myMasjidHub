class DonationsController < ApplicationController
  before_action :set_donation, only: %i[ show edit update destroy ]
  include Pagy::Backend
  Pagy::DEFAULT[:limit] = 7

  # GET /donations or /donations.json
  def index
    @donations = Donation.where(masjid_id: current_masjid.id).order(created_at: 'desc')
    @q = @donations.ransack(params[:q])
    @pagy, @table_donations = pagy(@donations)
  end

  # GET /donations/1 or /donations/1.json
  def show
  end

  # GET /donations/new
  def new
    @donation = Donation.new
    
  end

  # GET /donations/1/edit
  def edit
  end

  # POST /donations or /donations.json
  def create
    @donation = Donation.new(donation_params)
    @fundraiser = Fundraiser.where(id: params[:donation][:fundraiser_id]).first
    @donation.fundraiser_id = params[:donation][:fundraiser_id]
    @donation.masjid_id = @fundraiser.masjid_id

    respond_to do |format|
      if @donation.save
        format.html { redirect_to donation_url(@donation), notice: "Donation was successfully created." }
        format.json { render :show, status: :created, location: @donation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /donations/1 or /donations/1.json
  def update
    respond_to do |format|
      if @donation.update(donation_params)
        format.html { redirect_to donation_url(@donation), notice: "Donation was successfully updated." }
        format.json { render :show, status: :ok, location: @donation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /donations/1 or /donations/1.json
  def destroy
    @donation.destroy

    respond_to do |format|
      format.html { redirect_to donations_url, notice: "Donation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_donation
      @donation = Donation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def donation_params
      params.require(:donation).permit(:amount, :currency, :first_name, :last_name, :date, :fundraiser_id, :phone_number)
    end
end
