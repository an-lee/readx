# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id         :uuid             not null, primary key
#  content    :text
#  embedding  :vector
#  slug       :string
#  summary    :text
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_topics_on_slug  (slug) UNIQUE
#
require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
