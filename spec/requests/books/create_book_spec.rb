# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create Book', type: :request do
  let(:endpoint) { books_path }

  let(:headers) do
    {
      'Accept' => 'application/json'
    }
  end

  let(:author) do
    create :author
  end

  let(:params) do
    {
      title: Faker::Book.title,
      description: Faker::Lorem.characters(number: 500),
      publish_date: '1994-01-01',
      author_id: author.id
    }
  end

  describe 'POST /books' do
    context 'without params' do
      it 'should returns unprocessable_entity' do
        post endpoint, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'should returns errors validation' do
        post endpoint, headers: headers

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
      it 'should returns created http status' do
        post endpoint, headers: headers, params: params

        expect(response).to have_http_status(:created)
      end

      it 'should save record' do
        expect(Book.count).to eq(0)

        post endpoint, headers: headers, params: params

        expect(Book.count).to eq(1)
      end

      it 'should save record with valid params' do
        post endpoint, headers: headers, params: params

        book = Book.first

        expect(book.title).to eq(params[:title])
        expect(book.description).to eq(params[:description])
        expect(book.author_id).to eq(params[:author_id])
        expect(book.publish_date).to eq(Date.parse(params[:publish_date]))
      end
    end
  end
end
