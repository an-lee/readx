# frozen_string_literal: true

class DailyController < ApplicationController
  def index
    @topics =
      Topic
      .where(published_at: Time.zone.yesterday.all_day)
      .order(stories_count: :desc)
      .limit(10)
  end
end
