class CreateTranslations < ActiveRecord::Migration[7.0]
  def change
    create_table :translations, id: :uuid do |t|
      t.uuid :translatable_id, null: false
      t.string :translatable_type, null: false
      t.string :locale, null: false, index: true
      t.string :key, null: false
      t.text :value

      t.timestamps
    end

    add_index :translations, %i[translatable_id translatable_type locale key], unique: true, name: 'index_translations_on_translatable_and_locale_and_key'
  end
end
