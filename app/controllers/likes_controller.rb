# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = current_user.likes.build(tweet_id: params[:tweet_id])
    if @like.save
      flash[:success] = 'いいねできました'
      current_user.create_notification(@like.tweet, 'like')
    else
      flash[:error] = 'いいねに失敗しました'
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @like = current_user.likes.find_by!(tweet_id: params[:tweet_id])
    if @like.destroy
      flash[:success] = 'いいねを取り消しました'
    else
      flash[:error] = 'いいねの取り消しに失敗しました'
    end
    redirect_back(fallback_location: root_path)
  end
end
