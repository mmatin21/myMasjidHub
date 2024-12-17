class PledgesController < ApplicationController
  before_action :set_pledge, only: %i[ show edit update destroy ]

  # GET /pledges or /pledges.json
  def index
    @pledges = Pledge.all
  end

  # GET /pledges/1 or /pledges/1.json
  def show
  end

  # GET /pledges/new
  def new
    @contacts = Contact.where(masjid_id: current_masjid.id)
    @pledge = Pledge.new
    @contact = Contact.new
  end

  # GET /pledges/1/edit
  def edit
  end

  # POST /pledges or /pledges.json
  def create
    @pledge = Pledge.new(pledge_params)

    respond_to do |format|
      if @pledge.save
        format.html { redirect_to pledge_url(@pledge), notice: "Pledge was successfully created." }
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
