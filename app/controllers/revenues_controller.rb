class RevenuesController < ApplicationController
  before_action :authenticate_masjid!
  before_action :set_revenue, only: %i[show edit update destroy]
  include Pagy::Backend
  Pagy::DEFAULT[:limit] = 25

  # GET /revenues or /revenues.json
  def index
    @revenues = current_masjid.revenues.order(date: :desc)
    # Pagy and table filtering
    @q = @revenues.ransack(params[:q])
    @revenues = @q.result
    @pagy, @table_revenues = pagy(@revenues)
  end

  # GET /revenues/1 or /revenues/1.json
  def show; end

  # GET /revenues/new
  def new
    @revenue = Revenue.new
  end

  # GET /revenues/1/edit
  def edit; end

  # POST /revenues or /revenues.json
  def create
    @revenue = Revenue.new(revenue_params)
    @revenue.masjid_id = current_masjid.id

    respond_to do |format|
      if @revenue.save
        format.html { redirect_to revenue_url(@revenue), notice: 'Revenue was successfully created.' }
        format.turbo_stream do
          render turbo_stream: [turbo_stream.append('revenue_table', partial: 'tables/table_row',
                                                                     locals: { item: @revenue }),
                                turbo_stream.replace('flash',
                                                     partial: 'shared/alert', locals: { notice: 'Revenue was successfully created.' })]
        end
        format.json { render :show, status: :created, location: @revenue }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @revenue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /revenues/1 or /revenues/1.json
  def update
    respond_to do |format|
      if @revenue.update(revenue_params)
        format.html { redirect_to revenue_url(@revenue), notice: 'Revenue was successfully updated.' }
        format.turbo_stream do
          render turbo_stream: [turbo_stream.replace("item_#{@revenue.id}", partial: 'tables/table_row',
                                                                            locals: { item: @revenue }),
                                turbo_stream.replace("show_#{@revenue.id}", partial: 'revenues/revenue',
                                                                            locals: { revenue: @revenue }),
                                turbo_stream.replace('flash',
                                                     partial: 'shared/alert', locals: { notice: 'Revenue was successfully edited.' })]
        end
        format.json { render :show, status: :ok, location: @revenue }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @revenue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /revenues/1 or /revenues/1.json
  def destroy
    @revenue.destroy

    respond_to do |format|
      format.html { redirect_to revenues_url, notice: 'Revenue was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def export_csv
    @revenues = Revenue.where(masjid_id: current_masjid.id)

    respond_to do |format|
      format.csv { send_data @revenues.to_csv, filename: "revenues_#{Date.today}.csv" }
    end
  end

  def import_csv
    if params[:file].present?
      masjid_id = current_masjid.id # Get the masjid_id for the current user
      Revenue.import(params[:file], masjid_id)
      redirect_to revenues_path, notice: 'Records imported successfully.'
    else
      redirect_to revenues_path, alert: 'Please upload a valid CSV file.'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_revenue
    @revenue = Revenue.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def revenue_params
    params.require(:revenue).permit(:name, :amount, :date, :note)
  end
end
