# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'List Author', type: :request do
  let(:endpoint) { authors_path }

  let(:headers) do
    {
      'Accept' => 'application/json'
    }
  end

  let!(:authors) do
    create_list :author, 100
  end

  let(:params) do
    {
      page: 1,
      per_page: 10
    }
  end

  describe 'GET /authors' do
    context 'list authors with pagination info' do
      it 'should returns ok http status and list of authors' do
        get endpoint, headers: headers, params: params

        data = JSON.parse(response.body).dig('data', 'authors')

        expect(response).to have_http_status(:ok)
        expect(Author.where(id: data.pluck('id')).size).to eq(10)
      end

      it 'should returns information of pagination' do
        get endpoint, headers: headers, params: params

        data = JSON.parse(response.body)['data']

        expect(data['paginate']['current_page']).to eq 1
        expect(data['paginate']['per_page']).to eq 10
        expect(data['paginate']['total_entries']).to eq 100
        expect(data['paginate']['total_pages']).to eq 100 / 10
      end
    end
  end
end
