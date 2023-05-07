# frozen_string_literal: true

class TweetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tweets = current_user.recommended_tweets.page(params[:page])
  end

  def recommended
    @tweets = current_user.recommended_tweets.page(params[:page])
    render :index
  end

  def following
    @tweets = current_user.following_tweets.page(params[:page])
    render :index
  end
end
