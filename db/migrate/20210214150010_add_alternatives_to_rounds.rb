class AddAlternativesToRounds < ActiveRecord::Migration[6.1]
  def change
    add_column :rounds, :alternatives, :integer, array: true, default: []
  end
end
