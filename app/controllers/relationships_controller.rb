# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[create destroy]

  def create
    if current_user.follow(@user)
      flash[:success] = 'フォローしました'
    else
      flash[:error] = 'フォローに失敗しました'
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    if current_user.unfollow(@user)
      flash[:success] = 'フォローを解除しました'
    else
      flash[:error] = 'フォロー解除に失敗しました'
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
    return unless @user == current_user

    flash[:error] = '自分自身をフォローまたはアンフォローすることはできません'
    redirect_back(fallback_location: root_path)
  end
end
