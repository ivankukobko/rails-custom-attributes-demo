# frozen_string_literal: true

class UsersController < ApplicationController
  def update
    user = User.find(params[:id])
    # user.assign_attributes(permitted_params)
    json, status = if user.update(permitted_params)
                     [{}, :ok]
                   else
                     [{ errors: user.errors.messages }, :unprocessable_entity]
                   end

    render json:, status:
  rescue StandardError => e
    puts e
    puts e.backtrace
  end

  private

  def permitted_params
    params.require(:user)
          .permit(:name, preferences: {}, preferences_schema: {})
  end
end
