# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Delete Author', type: :request do
  let(:author) do
    create :author
  end

  let(:endpoint) { author_path(id: author.id) }
  let(:wrong_endpoint) { author_path(id: SecureRandom.uuid) }

  let(:headers) do
    {
      'Accept' => 'application/json'
    }
  end

  describe 'DELETE /authors' do
    context 'wrong id params' do
      before do
        author
      end

      it 'should returns not_found' do
        delete wrong_endpoint, headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with valid params' do
      before do
        author
      end
      it 'should returns ok http status' do
        delete endpoint, headers: headers

        expect(response).to have_http_status(:ok)
      end

      it 'should delete the record with valid params' do
        expect(Author.count).to eq(1)

        delete endpoint, headers: headers

        expect(Author.count).to eq(0)
      end
    end
  end
end
