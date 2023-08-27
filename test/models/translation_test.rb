# frozen_string_literal: true

# == Schema Information
#
# Table name: translations
#
#  id                :uuid             not null, primary key
#  key               :string           not null
#  locale            :string           not null
#  translatable_type :string           not null
#  value             :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  translatable_id   :uuid             not null
#
# Indexes
#
#  index_translations_on_locale                           (locale)
#  index_translations_on_translatable_and_locale_and_key  (translatable_id,translatable_type,locale,key) UNIQUE
#
require 'test_helper'

class TranslationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
