# frozen_string_literal: true

# == Schema Information
#
# Table name: llm_messages
#
#  id               :uuid             not null, primary key
#  llm_message_type :string
#  prompt           :text             not null
#  response         :jsonb
#  source_type      :string
#  status           :string           default("pending"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  source_id        :uuid
#
# Indexes
#
#  index_llm_messages_on_llm_message_type  (llm_message_type)
#  index_llm_messages_on_source            (source_id,source_type)
#
class LlmMessage < ApplicationRecord
end
