# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Update Book', type: :request do
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

  let(:params) do
    {
      title: Faker::Book.title,
      description: Faker::Lorem.characters(number: 500),
      publish_date: '1994-01-01',
      author_id: author.id
    }
  end

  describe 'PUT /books' do
    context 'wrong id params' do
      before do
        book
      end

      it 'should returns not_found' do
        put wrong_endpoint, headers: headers, params: params

        expect(response).to have_http_status(:not_found)
      end
    end
    context 'without params' do
      before do
        book
      end
      it 'should returns unprocessable_entity' do
        put endpoint, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'should returns errors validation' do
        put endpoint, headers: headers

        body = JSON.parse(response.body)

        expect(body['data']['title'].include?('can\'t be blank')).to be_truthy
        expect(body['data']['description'].include?('can\'t be blank')).to be_truthy
        expect(body['data']['publish_date'].include?('can\'t be blank')).to be_truthy
        expect(body['data']['publish_date'].include?('Invalid date format')).to be_truthy
        expect(body['data']['author_id'].include?('can\'t be blank')).to be_truthy
        expect(body['data']['author_id'].include?('Author not found')).to be_truthy
      end
    end

    context 'with valid params' do
      before do
        author
      end
      it 'should returns ok http status' do
        put endpoint, headers: headers, params: params

        expect(response).to have_http_status(:ok)
      end

      it 'should update record with valid params' do
        put endpoint, headers: headers, params: params

        book.reload

        expect(book.title).to eq(params[:title])
        expect(book.description).to eq(params[:description])
        expect(book.author_id).to eq(params[:author_id])
        expect(book.publish_date).to eq(Date.parse(params[:publish_date]))
      end
    end
  end
end
