class PrayersController < ApplicationController
  before_action :authenticate_masjid!
  before_action :set_prayer, only: %i[show edit update destroy]

  # GET /prayers or /prayers.json
  def index
    @prayers = current_masjid.prayers.order(adhaan: 'asc')
  end

  # GET /prayers/1 or /prayers/1.json
  def show; end

  # GET /prayers/new
  def new
    @prayer = Prayer.new
  end

  # GET /prayers/1/edit
  def edit; end

  # POST /prayers or /prayers.json
  def create
    @prayer = Prayer.new(prayer_params)
    @prayer.masjid_id = current_masjid.id

    respond_to do |format|
      if @prayer.save
        format.html { redirect_to prayer_url(@prayer), notice: 'Prayer was successfully created.' }
        format.turbo_stream do
          render turbo_stream: [turbo_stream.prepend('prayers', partial: 'prayers/prayer', locals: { prayer: @prayer }),
                                turbo_stream.replace('flash', partial: 'shared/alert',
                                                              locals: { notice: 'Prayer was successfully created.' })]
        end
        format.json { render :show, status: :created, location: @prayer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @prayer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prayers/1 or /prayers/1.json
  def update
    respond_to do |format|
      if @prayer.update(prayer_params)
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('flash',
                                                    partial: 'shared/alert', locals: { notice: 'Prayer was successfully edited.' })
        end
        format.html { redirect_to prayer_url(@prayer), notice: 'Prayer was successfully updated.' }
        format.json { render :show, status: :ok, location: @prayer }

      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @prayer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prayers/1 or /prayers/1.json
  def destroy
    @prayer.destroy

    respond_to do |format|
      format.html { redirect_to prayers_url, notice: 'Prayer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_prayer
    @prayer = Prayer.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def prayer_params
    params.require(:prayer).permit(:masjid_id, :name, :adhaan, :iqaamah)
  end
end
