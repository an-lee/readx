# frozen_string_literal: true

module Llm
  def self.openai
    @openai ||= OpenAI::Client.new(access_token: Rails.application.credentials.dig(:openai, :api_key))
  end
end
