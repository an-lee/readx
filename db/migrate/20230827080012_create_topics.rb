class CreateTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :topics, id: :uuid do |t|
      t.string :title, null: false
      t.string :slug, index: { unique: true }
      t.text :summary
      t.text :content
      t.vector :embedding

      t.timestamps
    end
  end
end
