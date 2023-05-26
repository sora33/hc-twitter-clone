# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = current_user.likes.build(tweet_id: params[:tweet_id])
    if @like.save
      flash[:success] = 'いいねできました'
    else
      flash[:error] = 'いいねに失敗しました'
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @like = Like.find_by(tweet_id: params[:tweet_id], user_id: current_user.id)
    if @like&.destroy
      flash[:success] = 'いいねを取り消しました'
    else
      flash[:error] = 'いいねの取り消しに失敗しました'
    end
    redirect_back(fallback_location: root_path)
  end
end
