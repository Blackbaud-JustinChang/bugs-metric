class CreateGraphs < ActiveRecord::Migration
  def change
    create_table :graphs do |t|
      t.string :name
      t.string :search
      t.date :start_date
      t.date :end_date
      t.string :product

      t.timestamps
    end
  end
end
