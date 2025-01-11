class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[ show edit update destroy ]
  include Pagy::Backend

  # GET /expenses or /expenses.json
  def index
    @expenses  = Expense.where(masjid_id: current_masjid.id)
    @pie_expenses  = Expense.where(masjid_id: current_masjid.id)

    
    
    #Area chart
    if params[:view] == "last_three_months"
      @area_expenses =  @expenses.group_by_last_three_months
    else
      @area_expenses =  @expenses.group_by_year_to_date
    end

    @area_expenses.each do |month|
      Rails.logger.debug "Month Name: #{month}" 
    end

    @labels ||= @area_expenses.keys
    @series ||= @area_expenses.values

    # Filter by year
    if params[:year].present?
      @pie_expenses = @pie_expenses.by_year(params[:year].to_i)
    end
    
    # Filter by year and month
    if params[:year].present? && params[:months].present?
      if params[:months] == "All Months"
        @pie_expenses = @pie_expenses.by_year(params[:year].to_i)
      else
        @pie_expenses = @pie_expenses.by_year_and_month(params[:year].to_i, params[:months].to_i)
      end
    end

    # Pie chart
    @pie_expenses = @pie_expenses.group(:name).sum(:amount)
    @pie_labels ||= @pie_expenses.keys
    @pie_series ||= @pie_expenses.values

    #Pagy and table filtering
    @q = @expenses.ransack(params[:q])
    @expenses = @q.result
    @pagy, @table_expenses = pagy(@expenses)

    # Fetch available years for the dropdown
    @available_years = Expense.pluck(Arel.sql("distinct extract(year from date)")).map(&:to_i)
  end

  # GET /expenses/1 or /expenses/1.json
  def show
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
  end

  # GET /expenses/1/edit
  def edit
  end

  # POST /expenses or /expenses.json
  def create
    @expense = Expense.new(expense_params)
    @expense.masjid_id = current_masjid.id

    if @expense.save
      redirect_to @expense, notice: 'Expense was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to expense_url(@expense), notice: "Expense was successfully updated." }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("item_#{@expense.id}", partial: "tables/table_row", locals: { item: @expense }) 
        end 
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1 or /expenses/1.json
  def destroy
    @expense.destroy

    respond_to do |format|
      format.html { redirect_to expenses_url, notice: "Expense was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def months
    @target = params[:target]
    masjid_expenses = Expense.where(masjid_id: current_masjid.id)
    @months = masjid_expenses.where('extract(year from date) = ?', params[:year].to_i)
                                 .select("DISTINCT extract(month from date) AS month")
                                 .map { |e| e.month.to_i }

    @months = @months.map { |m| [Date::MONTHNAMES[m], m] }
    @months = @months.prepend("All Months")

    @months.each do |month|
      Rails.logger.debug "Month Name: #{month}" 
    end
    respond_to do |format|
      format.turbo_stream
    end
  end

  def export_csv
    @expenses = Expense.where(masjid_id: current_masjid.id)

    respond_to do |format|
      format.csv { send_data @expenses.to_csv, filename: "expenses_#{Date.today}.csv" }
    end
  end

  def import_csv
    if params[:file].present?
      Rails.logger.info "Uploaded file: #{params[:file].original_filename}"
      Rails.logger.info "Masjid: #{current_masjid.id}"
      masjid_id = current_masjid.id # Get the masjid_id for the current user
      Expense.import(params[:file], masjid_id)
      redirect_to expenses_path, notice: "Records imported successfully."
    else
      redirect_to expenses_path, alert: "Please upload a valid CSV file."
    end
     Rails.logger.warn "No file uploaded"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def expense_params
      params.require(:expense).permit(
        :name,
        :amount,
        :date
      )
    end
end
