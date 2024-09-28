class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[ show edit update destroy ]

  # GET /expenses or /expenses.json
  def index
    @expenses = Expense.where(masjid_id: current_masjid.id)
    if params[:view] == "last_three_months"
      @view_expenses =  @expenses.group_by_last_three_months
    else
      @view_expenses =  @expenses.group_by_year_to_date
    end

    
    
    # Filter by year
    if params[:year].present?
      @expenses = @expenses.by_year(params[:year].to_i)
    end
    
    # Filter by year and month
    if params[:year].present? && params[:months].present?
      if params[:months] == "All Months"
        @expenses = @expenses.by_year(params[:year].to_i)
      else
        @expenses = @expenses.by_year_and_month(params[:year].to_i, params[:months].to_i)
      end
    end
    
    
    @view_expenses.each do |chart|
      Rails.logger.debug "year to date Data: #{chart}"  
    end

    @labels ||= @view_expenses.keys
    @series ||= @view_expenses.values

    @pie_expenses = @expenses.group(:name).sum(:amount)
    
    @pie_labels ||= @pie_expenses.keys
    @pie_series ||= @pie_expenses.values
    @expenses = @expenses.order(expense_date: 'desc')

    # Fetch available years for the dropdown
    @available_years = Expense.pluck(Arel.sql("distinct extract(year from expense_date)")).map(&:to_i)
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

    respond_to do |format|
      if @expense.save
        format.turbo_stream { render turbo_stream: turbo_stream.prepend('expenses', partial: 'expenses/expense', locals: {expense: @expense}) }
        format.html { redirect_to expense_url(@expense), notice: "Expense was successfully created." }
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to expense_url(@expense), notice: "Expense was successfully updated." }
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
    @months = Expense.where('extract(year from expense_date) = ?', params[:year].to_i)
                                 .select("DISTINCT extract(month from expense_date) AS month")
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
        :expense_date
      )
    end
end
