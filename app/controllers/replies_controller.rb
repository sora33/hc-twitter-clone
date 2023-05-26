# frozen_string_literal: true

class RepliesController < ApplicationController
  def create
    @tweet = Tweet.find(params[:tweet_id])
    @reply = @tweet.replies.build(reply_params)
    @reply.user = current_user
    if @reply.save
      redirect_to tweet_path(@tweet), flash: {success: '返信できました'}
    else
      @replies = @tweet.replies.page(params[:page])
      render 'tweets/show', status: :unprocessable_entity
    end
  end

  private

  def reply_params
    params.require(:tweet).permit(:content, :image)
  end
end
