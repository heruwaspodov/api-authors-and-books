# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Delete Book', type: :request do
  let(:author) do
    create :author
  end

  let(:book) do
    create :book, author: author
  end

  let(:endpoint) { book_path(id: book.id) }
  let(:wrong_endpoint) { book_path(id: SecureRandom.uuid) }

  let(:headers) do
    {
      'Accept' => 'application/json'
    }
  end

  describe 'DELETE /books' do
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
        book
      end
      it 'should returns ok http status' do
        delete endpoint, headers: headers

        expect(response).to have_http_status(:ok)
      end

      it 'should delete the record with valid params' do
        expect(Book.count).to eq(1)

        delete endpoint, headers: headers

        expect(Book.count).to eq(0)
      end
    end
  end
end
