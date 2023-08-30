# frozen_string_literal: true

class TopicsController < ApplicationController
  def index
    topics = Topic.hot.order(created_at: :desc)
    options = {
      after: params[:after],
      before: params[:before],
      order: { created_at: :desc }
    }.compact_blank

    @pagy, @topics = pagy_uuid_cursor topics, **options
    @page_title = t('.trending')
  end

  def show
    @topic = Topic.friendly.find params[:id]

    set_meta_tags @topic
  end
end
