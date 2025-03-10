class PledgesController < ApplicationController
  before_action :set_pledge, only: %i[ show edit update destroy ]
  include Pagy::Backend
  Pagy::DEFAULT[:limit] = 30

  # GET /pledges or /pledges.json
  def index
    @pledges = Pledge.where(masjid_id: current_masjid.id).order(created_at: 'desc')
    @q = @pledges.ransack(params[:q])
    @pledges = @q.result.includes(:contact)
    @pagy, @table_pledges = pagy(@pledges)
  end

  # GET /pledges/1 or /pledges/1.json
  def show
    @donations = Donation.where(pledge_id: @pledge.id)
  end

  # GET /pledges/new
  def new
    @contacts = Contact.where(masjid_id: current_masjid.id)
    @pledge = Pledge.new
    @contact = Contact.new
  end

  # GET /pledges/1/edit
  def edit
    @contacts = Contact.where(masjid_id: current_masjid.id)
    @contact = Contact.new
  end

  # POST /pledges or /pledges.json
  def create
    @pledge = Pledge.new(pledge_params)
    @pledge.masjid_id = current_masjid.id

    Rails.logger.debug "Month Name: #{params[:step]}" 
    respond_to do |format|
      if @pledge.save
        if params[:step].to_i == 2
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("turbo-modal", 
              partial: "pledges/success_donation", locals: { 
                donation: Donation.new, contact: Contact.new, pledge: Pledge.new, contact_id: @pledge.contact_id, pledge_id: @pledge.id, fundraiser_id: @pledge.fundraiser_id
              }
            )
          end
        end
        format.html { redirect_to pledge_url(@pledge), notice: "Pledge was successfully created." }
        format.turbo_stream do
          render turbo_stream: turbo_stream.prepend("pledge_table", partial: "tables/pledge_row", locals: { item: @pledge }) 
        end
        format.json { render :show, status: :created, location: @pledge }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pledge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pledges/1 or /pledges/1.json
  def update
    respond_to do |format|
      if @pledge.update(pledge_params)
        format.html { redirect_to pledge_url(@pledge), notice: "Pledge was successfully updated." }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("pledge_#{@pledge.id}", partial: "tables/pledge_row", locals: { item: @pledge }) 
        end 
        format.json { render :show, status: :ok, location: @pledge }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pledge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pledges/1 or /pledges/1.json
  def destroy
    @pledge.destroy

    respond_to do |format|
      format.html { redirect_to pledges_url, notice: "Pledge was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def export_csv
    @pledges = Pledge.where(masjid_id: current_masjid.id)

    respond_to do |format|
      format.csv { send_data @pledges.to_csv, filename: "pledges_#{Date.today}.csv" }
    end
  end

  def import_csv
    if params[:file].present?
      masjid_id = current_masjid.id # Get the masjid_id for the current user
      Pledge.import(params[:file], masjid_id)
      redirect_to pledges_path, notice: "Records imported successfully."
    else
      redirect_to pledges_path, alert: "Please upload a valid CSV file."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pledge
      @pledge = Pledge.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pledge_params
      params.require(:pledge).permit(:amount, :fundraiser_id, :contact_id)
    end
end
