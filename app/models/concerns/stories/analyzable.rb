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
      cryptocurrencies: {
        type: 'array',
        items: {
          type: 'string',
          description: 'Always use short symbols instead of full names. For example, use BTC instead of Bitcoin, use ETH instead of Ethereum. If you are not sure the short symbol of a cryptocurrency, ignore it. Do not contain any other characters. For example, if it contains $BTC, BTC/USD, use BTC only.'
        }
      },
      locale: {
        type: 'string',
        description: 'Language of the article, use ISO 639-1 code'
      }
    },
    required: %w[locale summary sentiment cryptocurrencies],
    additionalProperties: false
  }.freeze

  ANALYZE_CONTEXT = <<~CONTEXT
    You are a senrior editor and analyst at a cryptocurrency news website. \
    You are responsible for analyzing the news articles and extract the key information from the them. Rewrite them in a concise and easy to understand way if necessary. The key information includes: title, summary, type, score, sentiment, cryptocurrencies and locale.
  CONTEXT

  ANALYZE_PROMPT_TEMPLATE = <<~PROMPT
    The article content is provided below delimited by four backticks, in Markdown format. The article is scraped from Internet. It maybe some error instead of the real article because the original website denies our request. If so, please mark the score as 1 and sentiment as neutral.

    Article title: {title}
    Article content: ````{content}````

    Your task is help me extract the following information from the article.

    {format_instructions}
  PROMPT

  def analyze_content!
    return if analyzed?
    return if content.blank?

    analyze_message.chat if analyze_message.pending?

    json_response = json_parse analyze_message.result
    params = {
      title: json_response['title'],
      summary: json_response['summary'],
      sentiment: json_response['sentiment'],
      locale: json_response['locale'],
      score: json_response['score'],
      story_type: json_response['type']
    }.compact_blank

    update(**params) if params.present?

    json_response['cryptocurrencies']&.each do |tag_name|
      tag = Tag.find_by(name: tag_name)
      taggings.find_or_create_by(tag:) if tag.present?
    end

    if score <= 5 && may_drop?
      drop!
    elsif may_analyze?
      analyze!
    end
  end

  def analyze_content_async
    Stories::AnalyzeJob.perform_later id
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

  def json_parse(text)
    json = text.include?('```') ? text.strip.split(/```(?:json)?/)[1] : text.strip
    parsed = JSON.parse(json)
    parsed.compact_blank!
  rescue JSON::ParserError
    {}
  end

  def analyze_prompt
    @analyze_prompt ||= Langchain::Prompt::PromptTemplate.new(template: ANALYZE_PROMPT_TEMPLATE, input_variables: %w[title content format_instructions])
  end
end
