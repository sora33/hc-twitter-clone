# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update tweets retweets comments likes]
  before_action :is_current_user, only: %i[edit update]

  def show
    @tweets = @user.ordered_tweets.page(params[:page])
  end

  def edit
  end

  def update
    Rails.logger.debug "User params: #{user_params.inspect}"
    if @user.update(user_params)
      redirect_to @user, notice: 'プロフィールを変更できました。'
    else
      Rails.logger.debug "Validation errors: #{@user.errors.full_messages.join(', ')}"
      render :edit, status: :unprocessable_entity
    end
  end

  def retweets
    @tweets = @user.ordered_retweets.page(params[:page])
    render :show
  end

  def comments
    @tweets = @user.ordered_comments.page(params[:page])
    render :show
  end

  def likes
    @tweets = @user.ordered_likes.page(params[:page])
    render :show
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :profile_image, :header_image, :description, :place, :website, :birthday)
  end

  def is_current_user
    redirect_to root_path, notice: '無効なURLです' unless @user == current_user
  end
end
