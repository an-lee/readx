# frozen_string_literal: true

class TopicsController < ApplicationController
  def index
    @pagy, @topics = pagy Topic.all.order(created_at: :desc)
  end

  def show
    @topic = Topic.friendly.find params[:id]
  end
end
