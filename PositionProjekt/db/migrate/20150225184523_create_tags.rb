class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|

      t.string :Name

      t.belongs_to :Event, index: true

      t.timestamps
    end
  end
end
