# == Schema Information
#
# Table name: taggings
#
#  id            :uuid             not null, primary key
#  taggable_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  tag_id        :uuid             not null
#  taggable_id   :uuid             not null
#
# Indexes
#
#  index_taggings_on_tag_id_and_taggable  (tag_id,taggable_id,taggable_type) UNIQUE
#
require "test_helper"

class TaggingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
