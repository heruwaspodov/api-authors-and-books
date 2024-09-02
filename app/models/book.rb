# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :author

  after_save :reset_detail_cache

  def reset_detail_cache
    Rails.cache.delete("book:#{id}")
  end
end
