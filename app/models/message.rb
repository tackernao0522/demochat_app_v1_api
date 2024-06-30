# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy

  validates :content, presence: true, length: { maximum: 1000 }
  validate :content_cannot_be_only_whitespace

  before_save :sanitize_content

  private

  def content_cannot_be_only_whitespace
    errors.add(:content, "can't be only whitespace") if content.present? && content.strip.empty?
  end

  def sanitize_content
    self.content = content.strip
  end
end
