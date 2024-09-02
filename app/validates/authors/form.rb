# frozen_string_literal: true

module Authors
  class Form
    include ActiveModel::Validations

    attr_accessor :name, :bio, :birthdate

    def initialize(params)
      @name = params[:name]
      @bio = params[:bio]
      @birthdate = params[:birthdate]
    end

    validates :name, presence: true, length: { maximum: 100 }
    validates :bio, presence: true, length: { maximum: 500 }
    validates :birthdate, presence: true
    validate :validate_birthdate

    def validate_birthdate
      birthdate = Date.parse(@birthdate)

      errors.add(:birthdate, 'Must be in the past') if birthdate > DateTime.now
    rescue StandardError
      errors.add(:birthdate, 'Invalid date format')
    end
  end
end
