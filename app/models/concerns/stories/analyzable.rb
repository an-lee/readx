# frozen_string_literal: true

module Stories::Analyzable
  extend ActiveSupport::Concern

  ANALYZE_RESULT_JSON_SCHEMA = {
    type: 'object',
    properties: {
      title: {
        type: 'string',
        description: 'A clean title of the article, remove the website name, author name, etc. from the title.'
      },
      summary: {
        type: 'string',
        description: 'Summarize the article in 140 characters. If the article itself contains different events, only summarize the most revelant ones to the title.'
      },
      type: {
        type: 'string',
        enum: %w[fact opinion]
      },
      score: {
        type: 'integer',
        description: "Rate the quality score of the article from an editor's perspective. The score should be integer from 1 to 10. 1 means the article is in very low quality. For exmaple, it may has no meaningful content, irrevelant to crypto topic, or even scram. 10 means the article is in very high quality. It should be a good-written article, containing meaningful and important information. It should be a MUST-READ for every crypto investor."
      },
      sentiment: {
        type: 'string',
        enum: %w[positive negative neutral],
        description: "Predict how the crypto market will react to the article from an analyst's perspective. The sentiment should be one of the following: positive, negative, neutral."
      },
      tags: {
        type: 'array',
        items: {
          type: 'string',
          description: 'Extract the most important, relevant and meaningful tags from the article. Tags should be cryptocurrency symbols(BTC, ETH, etc), cryptocurrency topic(like De-Fi), key person, organizations, etc. Tags should be sorted by importance. Tags should be distinct as entities, not words. Use the short and concise form of the tag, for example, use "BTC" instead of "Bitcoin", use "De-Fi" instead of "Decentralized Finance". The number of tags should be between 1 and 3.'
        }
      },
      locale: {
        type: 'string',
        description: 'Language of the article, use ISO 639-1 code'
      }
    },
    required: %w[locale summary sentiment tags],
    additionalProperties: false
  }.freeze

  ANALYZE_CONTEXT = <<~CONTEXT
    You are a senrior editor and analyst at a cryptocurrency news website. \
    You are responsible for analyzing the news articles and extract the key information from the them. Rewrite them in a concise and easy to understand way if necessary. The key information includes: title, summary, type, score, sentiment, tags and locale.
  CONTEXT

  ANALYZE_PROMPT_TEMPLATE = <<~PROMPT
    The article content is provided below delimited by four backticks, in Markdown format.

    Article title: {title}
    Article content: ````{content}````

    Your task is help me extract the following information from the article.

    {format_instructions}
  PROMPT

  def analyze_content!
    return if analyzed?
    return if content.blank?

    analyze_message.chat if analyze_message.pending?

    json_response = llm_parser.parse analyze_message.result
    update!(
      title: json_response['title'],
      summary: json_response['summary'],
      sentiment: json_response['sentiment'],
      locale: json_response['locale'],
      score: json_response['score'],
      story_type: json_response['type']
    )
    json_response['tags'].each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name.upcase)
      taggings.find_or_create_by(tag:)
    end

    analyze! if may_analyze?
  end

  def analyze_message
    @analyze_message ||=
      analyze_messages.first || analyze_messages.create!(
        prompt: analyze_prompt_text,
        context: ANALYZE_CONTEXT
      )
  end

  def analyze_prompt_text
    @analyze_prompt_text ||=
      analyze_prompt.format(
        title:,
        content: content.truncate(8_000).gsub(/`{4}/, ''),
        format_instructions: llm_parser.get_format_instructions
      )
  end

  def llm_parser
    @llm_parser ||= Langchain::OutputParsers::StructuredOutputParser.from_json_schema(ANALYZE_RESULT_JSON_SCHEMA)
  end

  def analyze_prompt
    @analyze_prompt ||= Langchain::Prompt::PromptTemplate.new(template: ANALYZE_PROMPT_TEMPLATE, input_variables: %w[title content format_instructions])
  end
end
