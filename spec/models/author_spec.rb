# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author, type: :model do
  describe '#association' do
    it { should have_many(:books) }
  end
end
