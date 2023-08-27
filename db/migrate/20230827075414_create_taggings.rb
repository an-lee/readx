class CreateTaggings < ActiveRecord::Migration[7.0]
  def change
    create_table :taggings, id: :uuid do |t|
      t.uuid :tag_id, null: false
      t.uuid :taggable_id, null: false
      t.string:taggable_type, null: false

      t.timestamps
    end

    add_index :taggings, [:tag_id, :taggable_id, :taggable_type], unique: true, name: 'index_taggings_on_tag_id_and_taggable'
  end
end
