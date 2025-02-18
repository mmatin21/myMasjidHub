class DonationsController < ApplicationController
  before_action :authenticate_masjid!
  before_action :set_donation, only: %i[show edit update destroy]
  include Pagy::Backend
  Pagy::DEFAULT[:limit] = 30

  # GET /donations or /donations.json
  def index
    @donations = current_masjid.donations.order(created_at: 'desc')
    @q = @donations.ransack(params[:q])
    @donations = @q.result.includes(:contact, :fundraiser)
    @pagy, @table_donations = pagy(@donations)
  end

  # GET /donations/1 or /donations/1.json
  def show; end

  # GET /donations/new
  def new
    @donation = Donation.new
    @contacts = Contact.where(masjid_id: current_masjid.id)
    @contact = Contact.new
    @pledge = Pledge.new
  end

  # GET /donations/1/edit
  def edit
    @contacts = Contact.where(masjid_id: current_masjid.id)
    @contact = Contact.new
    @pledge = Pledge.new
  end

  # POST /donations or /donations.json
  def create
    @donation = Donation.new(donation_params)
    @fundraiser = Fundraiser.where(id: params[:donation][:fundraiser_id]).first
    @donation.fundraiser_id = params[:donation][:fundraiser_id]
    @donation.masjid_id = @fundraiser.masjid_id

    @donation.pledge_id = params[:pledge_id] unless params[:pledge_id].nil?

    respond_to do |format|
      if @donation.save
        format.html { redirect_to donation_url(@donation), notice: 'Donation was successfully created.' }
        format.turbo_stream do
          render turbo_stream: [turbo_stream.prepend('donation_table', partial: 'tables/donation_row',
                                                                       locals: { item: @donation }),
                                turbo_stream.replace('flash',
                                                     partial: 'shared/alert', locals: { notice: 'Donation was successfully created.' })]
        end
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
        format.html { redirect_to donation_url(@donation), notice: 'Donation was successfully updated.' }
        format.turbo_stream do
          render turbo_stream: [turbo_stream.replace("donation_#{@donation.id}", partial: 'tables/donation_row',
                                                                                 locals: { item: @donation }),
                                turbo_stream.replace("show_#{@donation.id}", partial: 'donations/donation',
                                                                             locals: { donation: @donation }),
                                turbo_stream.replace('flash',
                                                     partial: 'shared/alert', locals: { notice: 'Donation was successfully edited.' })]
        end
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
      format.html { redirect_to donations_url, notice: 'Donation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def export_csv
    @donations = Donation.where(masjid_id: current_masjid.id)

    respond_to do |format|
      format.csv { send_data @donations.to_csv, filename: "donations_#{Date.today}.csv" }
    end
  end

  def import_csv
    if params[:file].present?
      masjid_id = current_masjid.id # Get the masjid_id for the current user
      Donation.import(params[:file], masjid_id)
      redirect_to donations_path, notice: 'Records imported successfully.'
    else
      redirect_to donations_path, alert: 'Please upload a valid CSV file.'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_donation
    @donation = Donation.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def donation_params
    params.require(:donation).permit(:amount, :contact_id, :fundraiser_id, :pledge_id)
  end
end
