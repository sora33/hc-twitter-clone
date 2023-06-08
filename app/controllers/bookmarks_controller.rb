# frozen_string_literal: true

class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def index
    @bookmarks = current_user.bookmarked_tweets.page(params[:page])
  end

  def create
    @bookmark = current_user.bookmarks.build(tweet_id: params[:tweet_id])
    if @bookmark.save
      flash[:success] = 'ブックマークできました'
      current_user.create_notification(@bookmark.tweet, 'bookmark')
    else
      flash[:error] = 'ブックマークに失敗しました'
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @bookmark = current_user.bookmarks.find_by!(tweet_id: params[:tweet_id])
    if @bookmark.destroy
      flash[:success] = 'ブックマークを取り消しました'
    else
      flash[:error] = 'ブックマークの取り消しに失敗しました'
    end
    redirect_back(fallback_location: root_path)
  end
end
