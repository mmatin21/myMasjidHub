class RenameColumnsInRevenuesAndExpensesAndBalances < ActiveRecord::Migration[7.0]
  def change
    rename_column :revenues, :revenue_date, :date
    rename_column :expenses, :expense_date, :date
    rename_column :balances, :balance_date, :date
  end
end
