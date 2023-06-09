# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def notification_email(user)
    @user = user
    mail(to: @user.email, subject: 'twiietr(クローン)から新しい通知があります')
  end
end
