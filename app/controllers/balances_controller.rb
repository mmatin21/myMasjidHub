class BalancesController < ApplicationController
  before_action :set_balance, only: %i[ show edit update destroy ]

  # GET /balances or /balances.json
  def index
    @expenses  = Expense.where(masjid_id: current_masjid.id)
    @revenues = Revenue.where(masjid_id: current_masjid.id)

    if params[:view] == "last_three_months"
      @bar_revenues =  @revenues.group_by_last_three_months
      @bar_expenses =  @expenses.group_by_last_three_months
    else
      @bar_expenses =  @expenses.group_by_year_to_date
      @bar_revenues =  @revenues.group_by_year_to_date
    end

    @labels ||= @bar_revenues.keys
    @revenue_series ||= @bar_revenues.values
    @expense_series ||= @bar_expenses.values

    @profit = @revenue_series.sum - @expense_series.sum
    @profit_rate = (@profit / @revenue_series.sum) * 100

  end

  # GET /balances/1 or /balances/1.json
  def show
  end

  # GET /balances/new
  def new
    @balance = Balance.new
  end

  # GET /balances/1/edit
  def edit
  end

  # POST /balances or /balances.json
  def create
    @balance = Balance.new(balance_params)

    respond_to do |format|
      if @balance.save
        format.html { redirect_to balance_url(@balance), notice: "Balance was successfully created." }
        format.json { render :show, status: :created, location: @balance }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @balance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /balances/1 or /balances/1.json
  def update
    respond_to do |format|
      if @balance.update(balance_params)
        format.html { redirect_to balance_url(@balance), notice: "Balance was successfully updated." }
        format.json { render :show, status: :ok, location: @balance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @balance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /balances/1 or /balances/1.json
  def destroy
    @balance.destroy

    respond_to do |format|
      format.html { redirect_to balances_url, notice: "Balance was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_balance
      @balance = Balance.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def balance_params
      params.require(:balance).permit(:balance_date, :amount, :masjid_id)
    end
end
