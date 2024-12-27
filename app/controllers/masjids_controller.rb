class MasjidsController < ApplicationController
  before_action :set_masjid, only: %i[ show edit update destroy ]

  # GET /masjids/1 or /masjids/1.json
  def show
  end

  # GET /masjids/new
  def new
    @masjid = Masjid.new
  end

  # GET /masjids/1/edit
  def edit
  end

  # POST /masjids or /masjids.json
  def create
    @masjid = Masjid.new(masjid_params)

    respond_to do |format|
      if @masjid.save
        format.html { redirect_to masjid_url(@masjid), notice: "Masjid was successfully created." }
        format.json { render :show, status: :created, location: @masjid }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @masjid.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /masjids/1 or /masjids/1.json
  def update
    respond_to do |format|
      if @masjid.update(masjid_params)
        format.html { redirect_to masjid_url(@masjid), notice: "Masjid was successfully updated." }
        format.json { render :show, status: :ok, location: @masjid }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @masjid.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /masjids/1 or /masjids/1.json
  def destroy
    @masjid.destroy

    respond_to do |format|
      format.html { redirect_to masjids_url, notice: "Masjid was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_masjid
      @masjid = Masjid.find_by(id: current_masjid.id)
    end

    # Only allow a list of trusted parameters through.
    def masjid_params
      params.require(:masjid).permit(:name, :address, :city, :state, :zipcode)
    end
end
