class AddPublishedAtToTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :published_at, :datetime
  end
end
