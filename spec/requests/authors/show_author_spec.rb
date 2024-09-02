# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Show Author', type: :request do
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

  describe 'GET /authors' do
    context 'wrong id params' do
      before do
        author
      end

      it 'should returns not_found' do
        get wrong_endpoint, headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with valid params' do
      before do
        author
      end
      it 'should returns ok http status' do
        get endpoint, headers: headers

        expect(response).to have_http_status(:ok)
      end

      it 'should show the record with valid params' do
        get endpoint, headers: headers

        data = JSON.parse(response.body)['data']

        expect(data['id']).to eq author.id
        expect(data['name']).to eq author.name
        expect(data['bio']).to eq author.bio
        expect(Date.parse(data['birthdate'])).to eq author.birthdate
      end
    end
  end
end
