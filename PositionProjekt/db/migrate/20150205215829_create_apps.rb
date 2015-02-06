class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|

      t.belongs_to :user, index: true

      t.string :name

      t.string :appKey

      t.timestamps
    end
  end
end
