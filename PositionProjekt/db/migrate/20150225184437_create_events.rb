class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|


      t.belongs_to :Position, :Tag, :User

      t.datetime :EventDate

      t.timestamps

      t.string :EventName

      t.string :EventDescription

      t.references :Position, :Event, :User

    end
  end
end
