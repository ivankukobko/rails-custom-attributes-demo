# frozen_string_literal: true

class UsersController < ApplicationController
  def update
    user = User.find(params[:id])
    json, status = if user.update(permitted_params)
                     [{}, :ok]
                   else
                     [{ errors: user.errors.messages }, :unprocessable_entity]
                   end

    render json:, status:
  end

  private

  def permitted_params
    params.require(:user)
          .permit(:name, preferences: {}, preferences_schema: {})
  end
end
