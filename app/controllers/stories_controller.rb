# frozen_string_literal: true

class StoriesController < ApplicationController
  def index
    stories =
      if params[:tag]
        Tag.find_by(name: params[:tag].upcase)&.stories || Story.none
      else
        Story.classified
      end

    type = params[:type] || 'fact'
    stories =
      case type
      when 'opinion'
        stories.with_story_type(:opinion)
      when 'fact'
        stories.with_story_type(:fact)
      else
        stories
      end

    options = {
      after: params[:after],
      before: params[:before],
      order: { published_at: :desc }
    }.compact_blank

    @pagy, @stories = pagy_uuid_cursor stories, **options
    @page_title =
      if type == 'opinion'
        t('.opinions')
      else
        t('.news')
      end
  end

  def show
    @story = Story.find(params[:id])
    set_meta_tags @story
  end

  def content
    @story = Story.find(params[:story_id])
    ahoy.track 'View full content', story_id: params[:story_id]
  end
end
