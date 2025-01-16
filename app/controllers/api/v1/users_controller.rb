# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController

  def index
    authorize(current_user, :index?)

    users = CACHE_SERVICE.fetch(CacheKeys::LIST_USERS_KEY) do
      User.all.to_a
    end

    render_json(UserSerializer, users, :ok)
  end
end
