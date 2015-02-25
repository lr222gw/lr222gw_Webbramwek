class CreateTagOnEvents < ActiveRecord::Migration
  def change
    create_table :tag_on_events do |t|

      t.belongs_to :tag, index: true
      t.belongs_to :event, index: true
      t.timestamps
    end
  end
end
