# frozen_string_literal: true

class Stories::CollectFromGoogleJob < ApplicationJob
  queue_as :default

  def perform
    Story.collect_from_google
  end
end
