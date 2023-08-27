class CreateStories < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'vector'
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :stories, id: :uuid do |t|
      t.string :url, null: false, index: { unique: true }
      t.string :domain
      t.string :status, null: false, default: 'drafted'

      t.jsonb :source, null: false, default: {}
      t.text :html
      t.string :title
      t.datetime :published_at

      t.string :locale, null: false, default: 'en'
      t.string :story_type, null: false, index: true, default: 'fact'
      t.string :sentiment, index: true, default: 'neutral'
      t.integer :score, null: false, default: 5
      t.text :summary

      t.uuid :topic_id, index: true
      t.vector :embedding

      t.timestamps
    end
  end
end
