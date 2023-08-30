# frozen_string_literal: true

class Ahoy::VisitResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :visit_token
  attribute :visitor_token
  attribute :ip
  attribute :user_agent
  attribute :referrer
  attribute :referring_domain
  attribute :landing_page
  attribute :browser
  attribute :os
  attribute :device_type
  attribute :country
  attribute :region
  attribute :city
  attribute :latitude
  attribute :longitude
  attribute :utm_source
  attribute :utm_medium
  attribute :utm_term
  attribute :utm_content
  attribute :utm_campaign
  attribute :app_version
  attribute :os_version
  attribute :platform
  attribute :started_at

  # Associations
  attribute :events
  attribute :user

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
