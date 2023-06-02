# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action :find_user, only: :create
  before_action :find_or_create_conversation, only: :create

  def index
    @conversations = current_user.conversations
  end

  def show
    @conversations = current_user.conversations
    @conversation = Conversation.find(params[:id])
    @message = Message.new
  end

  def create
    if @find_or_create_conversation.save
      redirect_to conversation_path(@find_or_create_conversation), flash: { success: 'DMを送信できます' }
    else
      redirect_to user_path(@user), status: :unprocessable_entity, flash: { success: 'エラーになりました。' }
    end
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end

  def find_or_create_conversation
    @find_or_create_conversation = Conversation.between(current_user.id, @user.id).first
    @find_or_create_conversation ||= Conversation.new(sender_id: current_user.id, recipient_id: @user.id)
  end
end
