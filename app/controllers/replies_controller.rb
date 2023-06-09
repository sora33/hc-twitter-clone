# frozen_string_literal: true

class RepliesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tweet, only: %i[create]
  def create
    @reply = @tweet.replies.build(reply_params)
    @reply.user = current_user
    if @reply.save
      redirect_to tweet_path(@tweet), flash: { success: '返信できました' }
      current_user.create_notification(@tweet, 'reply')
    else
      @replies = @tweet.replies.page(params[:page])
      render 'tweets/show', status: :unprocessable_entity
    end
  end

  private

  def reply_params
    params.require(:tweet).permit(:content, :image)
  end

  def set_tweet
    @tweet = Tweet.find(params[:tweet_id])
  end
end
