class CreateLlmMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :llm_messages, id: :uuid do |t|
      t.string :llm_message_type, index: true
      t.uuid :source_id
      t.string :source_type
      t.text :context
      t.text :prompt, null: false
      t.jsonb :response
      t.string :status, null: false, default: 'pending'

      t.timestamps
    end

    add_index :llm_messages, [:source_id, :source_type], name: 'index_llm_messages_on_source'
  end
end
