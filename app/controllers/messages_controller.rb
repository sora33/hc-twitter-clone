# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: :create

  def create
    @message = @conversation.messages.build(message_params)
    @message.user = current_user

    if @message.save
      redirect_to @conversation, flash: { success: 'メッセージを送信しました' }
    else
      flash.now[:alert] = @message.errors.full_messages.join(', ')
      redirect_to @conversation, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end

  def set_conversation
    @conversation = current_user.conversations.find(params[:conversation_id])
  end
end
