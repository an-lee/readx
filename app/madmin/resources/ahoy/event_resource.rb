# frozen_string_literal: true

class Ahoy::EventResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :name
  attribute :properties
  attribute :time

  # Associations
  attribute :visit
  attribute :user

  # Uncomment this to customize the display name of records in the admin area.
  # def self.display_name(record)
  #   record.name
  # end

  # Uncomment this to customize the default sort column and direction.
  def self.default_sort_column
    'time'
  end

  def self.default_sort_direction
    'desc'
  end
end
