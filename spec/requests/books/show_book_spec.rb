# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Show Book', type: :request do
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

  describe 'GET /books' do
    context 'wrong id params' do
      before do
        book
      end

      it 'should returns not_found' do
        get wrong_endpoint, headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with valid params' do
      before do
        book
      end
      it 'should returns ok http status' do
        get endpoint, headers: headers

        expect(response).to have_http_status(:ok)
      end

      it 'should show the record with valid params' do
        get endpoint, headers: headers

        data = JSON.parse(response.body)['data']

        expect(data['id']).to eq book.id
        expect(data['title']).to eq(book.title)
        expect(data['description']).to eq(book.description)
        expect(data['author_id']).to eq(book.author_id)
        expect(Date.parse(data['publish_date'])).to eq book.publish_date
      end
    end
  end
end
