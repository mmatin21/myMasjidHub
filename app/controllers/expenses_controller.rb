class ExpensesController < ApplicationController
  before_action :authenticate_masjid!
  before_action :set_expense, only: %i[show edit update destroy]
  include CsvImportable
  include Pagy::Backend
  Pagy::DEFAULT[:limit] = 25

  # GET /expenses or /expenses.json
  def index
    @expenses = current_masjid.expenses.order(date: :desc)

    # Pagy and table filtering
    @q = @expenses.ransack(params[:q])
    @expenses = @q.result
    @pagy, @table_expenses = pagy(@expenses)
  end

  # GET /expenses/1 or /expenses/1.json
  def show; end

  # GET /expenses/new
  def new
    @expense = Expense.new
  end

  # GET /expenses/1/edit
  def edit; end

  # POST /expenses or /expenses.json
  def create
    @expense = Expense.new(expense_params)
    @expense.masjid_id = current_masjid.id

    respond_to do |format|
      if @expense.save
        format.html { redirect_to expense_url(@expense), notice: 'Expense was successfully created.' }
        format.turbo_stream do
          render turbo_stream: [turbo_stream.append('expense_table', partial: 'tables/table_row',
                                                                     locals: { item: @expense }),
                                turbo_stream.replace('flash',
                                                     partial: 'shared/alert', locals: { notice: 'Expense was successfully created.' })]
        end
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
        format.html { redirect_to expense_url(@expense), notice: 'Expense was successfully updated.' }
        format.turbo_stream do
          render turbo_stream: [turbo_stream.replace("item_#{@expense.id}", partial: 'tables/table_row',
                                                                            locals: { item: @expense }),
                                turbo_stream.replace("show_#{@expense.id}", partial: 'expenses/expense',
                                                                            locals: { expense: @expense }),
                                turbo_stream.replace('flash',
                                                     partial: 'shared/alert', locals: { notice: 'Expense was successfully edited.' })]
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
      format.html { redirect_to expenses_url, notice: 'Expense was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def months
    @target = params[:target]
    masjid_expenses = Expense.where(masjid_id: current_masjid.id)
    @months = masjid_expenses.where('extract(year from date) = ?', params[:year].to_i)
                             .select('DISTINCT extract(month from date) AS month')
                             .map { |e| e.month.to_i }

    @months = @months.map { |m| [Date::MONTHNAMES[m], m] }
    @months = @months.prepend('All Months')

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
      :date,
      :expense_type,
      :merchant
    )
  end
end
