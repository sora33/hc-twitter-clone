# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :action_user, class_name: 'User'
  belongs_to :passive_user, class_name: 'User'
  belongs_to :tweet

  validate :action_equal_passive_user

  private

  def action_equal_passive_user
    errors.add(:base, '同一人物には通知を発行できません。') if action_user_id == passive_user_id
  end
end
