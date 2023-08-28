# frozen_string_literal: true

class Madmin::SessionsController < Madmin::ApplicationController
  skip_before_action :authenticate_admin!, only: %i[new create]
  layout false

  def new
  end

  def create
    admin = Administrator.find_by(name: params[:name])
    admin_sign_in(admin.id) if admin&.authenticate(params[:password])

    if current_admin.present?
      redirect_to '/madmin'
    else
      redirect_to '/madmin/login'
    end
  end

  def delete
    admin_sign_out
    redirect_to '/madmin/login'
  end
end
