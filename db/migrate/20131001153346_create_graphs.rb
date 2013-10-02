class CreateGraphs < ActiveRecord::Migration
  def change
    create_table :graphs do |t|
      t.string :name
      t.string :search
      t.boolean :in_summary

      t.timestamps
    end
  end
end
