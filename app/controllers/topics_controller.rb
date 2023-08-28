# frozen_string_literal: true

class TopicsController < ApplicationController
  def index
    @pagy, @topics = pagy Topic.hot.order(created_at: :desc)
  end

  def show
    @topic = Topic.friendly.find params[:id]

    set_meta_tags @topic
  end
end
