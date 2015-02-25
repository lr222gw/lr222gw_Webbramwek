class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|



      t.integer :lng
      t.integer :lat

      t.timestamps
    end
  end
end
