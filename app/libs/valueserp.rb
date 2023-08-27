# frozen_string_literal: true

module Valueserp
  def self.api
    @api ||= Valueserp::API.new(Rails.application.credentials.dig(:valueserp, :api_key))
  end
end
