# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id            :uuid             not null, primary key
#  embedding     :vector
#  published_at  :datetime
#  slug          :string
#  stories_count :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  source_id     :uuid             not null
#
# Indexes
#
#  index_topics_on_slug       (slug) UNIQUE
#  index_topics_on_source_id  (source_id)
#
require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
