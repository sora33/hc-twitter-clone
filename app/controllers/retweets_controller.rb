# frozen_string_literal: true

class RetweetsController < ApplicationController
  before_action :authenticate_user!

  def create
    @retweet = current_user.retweets.build(tweet_id: params[:tweet_id])
    if @retweet.save
      flash[:success] = 'リツイートできました'
    else
      flash[:error] = 'リツイートに失敗しました'
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @retweet = current_user.retweets.find_by!(tweet_id: params[:tweet_id])
    if @retweet.destroy
      flash[:success] = 'リツイートを取り消しました'
    else
      flash[:error] = 'リツイートの取り消しに失敗しました'
    end
    redirect_back(fallback_location: root_path)
  end
end
