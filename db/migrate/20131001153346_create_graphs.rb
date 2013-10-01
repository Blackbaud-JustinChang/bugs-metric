class CreateGraphs < ActiveRecord::Migration
  def change
    create_table :graphs do |t|
      t.string :name
      t.string :search
      t.string :start_date
      t.string :end_date
      t.string :product

      t.timestamps
    end
  end
end
