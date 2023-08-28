# frozen_string_literal: true

module Madmin
  class ApplicationController < Madmin::BaseController
    before_action :authenticate_admin!

    def authenticate_admin!
      redirect_to '/' if current_admin.blank?
    end

    def current_admin
      @current_admin ||= Administrator.find_by(id: session[:current_admin_id])
    end

    def admin_sign_in(id)
      session[:current_admin_id] = id
    end

    def admin_sign_out
      session[:current_admin_id] = nil
    end
  end
end
