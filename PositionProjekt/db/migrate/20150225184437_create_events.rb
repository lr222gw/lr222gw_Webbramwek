class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|


      t.belongs_to :position, index: true
      #t.belongs_to :tag, index: true
      t.belongs_to :user, index: true # Dessa måste anges med små bokstäver...

      t.datetime :eventDate

      t.timestamps

      t.string :name

      t.string :desc

      #t.references :Position, :Tag, :User #denna kan ej vara med då vi använder t.belongs_to <- det blir duplicationer...

    end
  end
end
