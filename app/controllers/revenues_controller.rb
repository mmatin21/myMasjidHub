class RevenuesController < ApplicationController
  before_action :set_revenue, only: %i[ show edit update destroy ]
  include Pagy::Backend
  Pagy::DEFAULT[:limit] = 7

  # GET /revenues or /revenues.json
  def index
    @revenues = Revenue.where(masjid_id: current_masjid.id)
    @pie_revenues  = Revenue.where(masjid_id: current_masjid.id)

    #Area chart
    if params[:view] == "last_three_months"
      @area_revenues =  @revenues.group_by_last_three_months
    else
      @area_revenues =  @revenues.group_by_year_to_date
    end

    @area_revenues.each do |month|
      Rails.logger.debug "Month Name: #{month}" 
    end

    @labels ||= @area_revenues.keys
    @series ||= @area_revenues.values

    # Filter by year
    if params[:year].present?
      @pie_revenues = @pie_revenues.by_year(params[:year].to_i)
    end
    
    # Filter by year and month
    if params[:year].present? && params[:months].present?
      if params[:months] == "All Months"
        @pie_revenues = @pie_revenues.by_year(params[:year].to_i)
      else
        @pie_revenues = @pie_revenues.by_year_and_month(params[:year].to_i, params[:months].to_i)
      end
    end

    # Pie chart
    @pie_revenues = @pie_revenues.group(:name).sum(:amount)
    @pie_labels ||= @pie_revenues.keys
    @pie_series ||= @pie_revenues.values

    #Pagy and table filtering
    @q = @revenues.ransack(params[:q])
    @revenues = @q.result
    @pagy, @table_revenues = pagy(@revenues)

    # Fetch available years for the dropdown
    @available_years = Revenue.pluck(Arel.sql("distinct extract(year from date)")).map(&:to_i)
  end

  # GET /revenues/1 or /revenues/1.json
  def show
  end

  # GET /revenues/new
  def new
    @revenue = Revenue.new
  end

  # GET /revenues/1/edit
  def edit
  end

  # POST /revenues or /revenues.json
  def create
    @revenue = Revenue.new(revenue_params)
    @revenue.masjid_id = current_masjid.id


    respond_to do |format|
      if @revenue.save
        format.html { redirect_to revenue_url(@revenue), notice: "Revenue was successfully created." }
        format.turbo_stream do
          render turbo_stream: turbo_stream.append("revenue_table", partial: "tables/table_row", locals: { item: @revenue }) 
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
        format.html { redirect_to revenue_url(@revenue), notice: "Revenue was successfully updated." }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("item_#{@revenue.id}", partial: "tables/table_row", locals: { item: @revenue }) 
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
      format.html { redirect_to revenues_url, notice: "Revenue was successfully destroyed." }
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
      redirect_to revenues_path, notice: "Records imported successfully."
    else
      redirect_to revenues_path, alert: "Please upload a valid CSV file."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_revenue
      @revenue = Revenue.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def revenue_params
      params.require(:revenue).permit(:name, :amount, :date)
    end
end
