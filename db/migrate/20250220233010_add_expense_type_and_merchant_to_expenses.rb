class AddExpenseTypeAndMerchantToExpenses < ActiveRecord::Migration[7.0]
  def change
    add_column :expenses, :expense_type, :string
    add_column :expenses, :merchant, :string
  end
end
