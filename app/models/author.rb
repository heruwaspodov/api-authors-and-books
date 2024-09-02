# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :books

  after_save :reset_detail_cache

  def reset_detail_cache
    Rails.cache.delete("author:#{id}")
  end
end
