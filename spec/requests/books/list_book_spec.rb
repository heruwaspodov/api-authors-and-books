# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'List Book', type: :request do
  let(:endpoint) { books_path }

  let(:headers) do
    {
      'Accept' => 'application/json'
    }
  end

  let(:author) do
    create :author
  end

  let!(:books) do
    create_list :book, 100, author: author
  end

  let(:params) do
    {
      page: 1,
      per_page: 10
    }
  end

  describe 'GET /books' do
    context 'list books with pagination info' do
      it 'should returns ok http status and list of books' do
        get endpoint, headers: headers, params: params

        data = JSON.parse(response.body).dig('data', 'books')

        expect(response).to have_http_status(:ok)
        expect(Book.where(id: data.pluck('id')).size).to eq(10)
      end

      it 'should returns information of pagination' do
        get endpoint, headers: headers, params: params

        data = JSON.parse(response.body)['data']

        expect(data['paginate']['current_page']).to eq 1
        expect(data['paginate']['per_page']).to eq 10
        expect(data['paginate']['total_entries']).to eq 100
        expect(data['paginate']['total_pages']).to eq 100 / 10
      end

      it 'should returns expected key of books' do
        get endpoint, headers: headers, params: params

        data = JSON.parse(response.body).dig('data', 'books')
        key = data.flat_map(&:keys).uniq

        expect(key.include?('id')).to be_truthy
        expect(key.include?('title')).to be_truthy
        expect(key.include?('description')).to be_truthy
        expect(key.include?('publish_date')).to be_truthy
        expect(key.include?('author')).to be_truthy
      end
    end
  end
end
