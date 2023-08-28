# frozen_string_literal: true

class StoryResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :url
  attribute :domain
  attribute :status
  attribute :source
  attribute :html
  attribute :title
  attribute :published_at
  attribute :locale
  attribute :story_type
  attribute :sentiment
  attribute :score
  attribute :summary
  attribute :embedding, form: false, index: false
  attribute :created_at, form: false
  attribute :updated_at, form: false

  # Associations
  attribute :topic
  attribute :llm_messages
  attribute :analyze_messages
  attribute :embed_messages
  attribute :taggings
  attribute :tags
  attribute :translations

  # Uncomment this to customize the display name of records in the admin area.
  # def self.display_name(record)
  #   record.name
  # end

  # Uncomment this to customize the default sort column and direction.
  # def self.default_sort_column
  #   "created_at"
  # end
  #
  # def self.default_sort_direction
  #   "desc"
  # end
end
