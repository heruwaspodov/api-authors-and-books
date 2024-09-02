# frozen_string_literal: true

module Books
  class Form
    include ActiveModel::Validations

    attr_accessor :title, :description, :publish_date, :author_id

    def initialize(params)
      @title = params[:title]
      @description = params[:description]
      @publish_date = params[:publish_date]
      @author_id = params[:author_id]
    end

    validates :title, presence: true, length: { maximum: 100 }
    validates :description, presence: true, length: { maximum: 500 }
    validates :publish_date, presence: true
    validates :author_id, presence: true
    validate :validate_publish_date
    validate :validate_author_id

    def validate_publish_date
      publish_date = Date.parse(@publish_date)

      errors.add(:publish_date, 'Must be in the past') if publish_date > DateTime.now
    rescue StandardError
      errors.add(:publish_date, 'Invalid date format')
    end

    def validate_author_id
      author = Author.find_by_id(@author_id)

      return if author.present?

      errors.add(:author_id, 'Author not found')
    end
  end
end
