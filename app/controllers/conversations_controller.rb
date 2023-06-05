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
    conversation = find_or_create_conversation(@user)
    if conversation.save!
      redirect_to conversation_path(conversation), flash: { success: 'DMを送信できます' }
    else
      redirect_to user_path(@user), status: :unprocessable_entity, flash: { success: 'エラーになりました。' }
    end
  end

  private

  def set_conversations
    @conversations = current_user.conversations.order(created_at: :desc)
  end

  # 会話が存在するか確認し、なければ作成する
  def find_or_create_conversation(user)
    Conversation.between(current_user.id, user.id).first ||
      Conversation.find_or_create_by(sender_id: current_user.id, recipient_id: user.id)
  end
end
