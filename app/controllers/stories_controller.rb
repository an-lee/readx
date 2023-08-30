# frozen_string_literal: true

class StoriesController < ApplicationController
  def index
    type = params[:type] || 'fact'
    tag = Tag.find_by(name: params[:tag].upcase) if params[:tag]

    stories =
      if tag
        tag.stories
      else
        Story.classified
      end

    stories =
      case type
      when 'opinion'
        stories.with_story_type(:opinion)
      when 'fact'
        stories.with_story_type(:fact)
      else
        stories
      end

    @pagy, @stories = pagy stories.order(published_at: :desc)
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
