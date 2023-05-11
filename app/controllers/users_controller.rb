# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show tweets retweets comments likes]

  def show
    @tweets = @user.ordered_tweets.page(params[:page])
  end

  def retweets
    @tweets = Kaminari.paginate_array(@user.ordered_retweets).page(params[:page])
    render :show
  end

  def comments
    @tweets = Kaminari.paginate_array(@user.ordered_comments).page(params[:page])
    render :show
  end

  def likes
    @tweets = Kaminari.paginate_array(@user.ordered_likes).page(params[:page])
    render :show
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
