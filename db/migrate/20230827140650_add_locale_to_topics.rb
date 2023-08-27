class AddLocaleToTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :locale, :string, null: false, default: 'en'
  end
end
