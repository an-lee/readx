# frozen_string_literal: true

class DailyController < ApplicationController
  def index
    @topics =
      Topic
      .where(published_at: Time.now.yesterday.utc.all_day)
      .order(stories_count: :desc)
      .limit(10)

    @page_title = t('.daily_topics')
    @page_description = @topics.map(&:title_text).join(' | ')
    @page_keywords = @topics.map(&:tags)&.flatten&.map(&:name)&.uniq&.join(', ')
  end
end
