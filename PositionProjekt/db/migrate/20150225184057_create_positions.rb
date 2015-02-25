class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      

      t.string :lng
      t.string :lat

      t.timestamps
    end
  end
end
