class CreateTagOnEvents < ActiveRecord::Migration
  def change
    create_table :tag_on_events, :id => false do |t| #:id => false <- tar bort idt från TagOnEvent...

      t.belongs_to :tag, index: true
      t.belongs_to :event, index: true

      t.timestamps
    end
  end
end
