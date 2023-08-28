class CreateTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :topics, id: :uuid do |t|
      t.string :slug, index: { unique: true }
      t.uuid :source_id, null: false, index: true
      t.integer :stories_count, default: 0, null: false
      t.vector :embedding

      t.timestamps
    end
  end
end
