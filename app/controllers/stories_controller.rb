# frozen_string_literal: true

class StoriesController < ApplicationController
  def index
    type = params[:type] || 'fact'
    stories = Story.classified.order(published_at: :desc)

    stories =
      case type
      when 'opinion'
        stories.with_story_type(:opinion)
      when 'fact'
        stories.with_story_type(:fact)
      else
        stories
      end

    @pagy, @stories = pagy stories
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
  end
end
