class AddDueDateToBorrowing < ActiveRecord::Migration[8.0]
  def change
    add_column :borrowings, :due_date, :datetime
  end
end
