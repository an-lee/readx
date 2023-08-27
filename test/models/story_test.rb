# frozen_string_literal: true

# == Schema Information
#
# Table name: stories
#
#  id           :uuid             not null, primary key
#  domain       :string
#  embedding    :vector
#  html         :text
#  locale       :string           default("en"), not null
#  published_at :datetime
#  score        :integer          default(5), not null
#  sentiment    :string           default("neutral")
#  source       :jsonb            not null
#  status       :string           default("drafted"), not null
#  story_type   :string           default("fact"), not null
#  summary      :text
#  title        :string
#  url          :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  topic_id     :uuid
#
# Indexes
#
#  index_stories_on_sentiment   (sentiment)
#  index_stories_on_story_type  (story_type)
#  index_stories_on_topic_id    (topic_id)
#  index_stories_on_url         (url) UNIQUE
#
require 'test_helper'

class StoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
