# frozen_string_literal: true

class TweetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tweets, only: %i[index create]

  def index; end

  def create
    @tweet = current_user.tweets.build(tweet_params)
    if @tweet.save
      redirect_to root_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  def following
    @tweets = current_user.following_tweets.page(params[:page])
    render :index
  end

  def tweet_params
    params.require(:tweet).permit(:content, :image)
  end

  def set_tweets
    @tweets = current_user.all_tweets.page(params[:page])
  end
end
