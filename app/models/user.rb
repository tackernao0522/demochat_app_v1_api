# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :messages, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }

  def synchronize_email_and_uid
    self.uid = email if uid.blank?
  end

  def no_callbacks
    self.class.skip_callback(:save, :before, :synchronize_email_and_uid, raise: false)
    yield
  ensure
    self.class.set_callback(:save, :before, :synchronize_email_and_uid, raise: false)
  end
end
