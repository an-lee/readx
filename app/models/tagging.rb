# frozen_string_literal: true

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
class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :taggable, polymorphic: true
end
