# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action :set_conversations, only: %i[index show]

  def index; end

  def show
    @conversation = @conversations.find(params[:id])
    @message = Message.new
  end

  def create
    @user = User.find(params[:user_id])
    conversation = current_user.find_or_create_conversation_with(@user)
    if conversation.save!
      redirect_to conversation_path(conversation), flash: { success: 'DMを送信できます' }
    else
      redirect_to user_path(user), status: :unprocessable_entity, flash: { success: 'エラーになりました。' }
    end
  end

  private

  def set_conversations
    @conversations = current_user.conversations.order(created_at: :desc)
  end
end
