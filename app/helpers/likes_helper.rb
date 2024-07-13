# frozen_string_literal: true

module LikesHelper
  def like_count_message(likes)
    count = likes.count
    "#{count} #{count == 1 ? 'like' : 'likes'}"
  end
end
