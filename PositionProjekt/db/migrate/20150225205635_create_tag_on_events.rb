class CreateTagOnEvents < ActiveRecord::Migration
  def change
    create_table :tag_on_events do |t| #:id => false <- tar bort idt från TagOnEvent... <- Förstörde senare(när jag försökte läsa in tagOnEvents från events så i to_json)... ", :id => false"

      t.belongs_to :tag, index: true
      t.belongs_to :event, index: true

      t.timestamps
    end
  end
end
