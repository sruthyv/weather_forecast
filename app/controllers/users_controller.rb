# frozen_string_literal: true

# UsersController
class UsersController < ApplicationController
  def index
    render 'index'
  end

  def change_temperature
    current_user.temperature = params[:data]
    if current_user.save
      render json: {}, status: :ok
    else
      render json: {}, status: :not_found
    end
  end
end
