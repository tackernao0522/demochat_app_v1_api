# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :message

  validates :user_id,
            uniqueness: { scope: :message_id,
                          message: I18n.t('activerecord.errors.models.like.attributes.user_id.taken') }
end
