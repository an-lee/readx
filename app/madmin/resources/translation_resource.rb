# frozen_string_literal: true

class TranslationResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :locale
  attribute :key
  attribute :value
  attribute :created_at, form: false
  attribute :updated_at, form: false

  # Associations
  attribute :translatable
  attribute :llm_messages

  # Uncomment this to customize the display name of records in the admin area.
  # def self.display_name(record)
  #   record.name
  # end

  # Uncomment this to customize the default sort column and direction.
  def self.default_sort_column
    'created_at'
  end

  def self.default_sort_direction
    'desc'
  end
end
