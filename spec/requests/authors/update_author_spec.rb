# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Update Author', type: :request do
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

  let(:params) do
    {
      name: Faker::Name.name,
      bio: Faker::Lorem.characters(number: 100),
      birthdate: '1994-01-01'
    }
  end

  describe 'PUT /authors' do
    context 'wrong id params' do
      before do
        author
      end

      it 'should returns not_found' do
        put wrong_endpoint, headers: headers, params: params

        expect(response).to have_http_status(:not_found)
      end
    end
    context 'without params' do
      before do
        author
      end
      it 'should returns unprocessable_entity' do
        put endpoint, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'should returns errors validation' do
        put endpoint, headers: headers

        body = JSON.parse(response.body)

        expect(body['data']['name'].include?('can\'t be blank')).to be_truthy
        expect(body['data']['bio'].include?('can\'t be blank')).to be_truthy
        expect(body['data']['birthdate'].include?('can\'t be blank')).to be_truthy
        expect(body['data']['birthdate'].include?('Invalid date format')).to be_truthy
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

        author.reload

        expect(author.name).to eq(params[:name])
        expect(author.bio).to eq(params[:bio])
        expect(author.birthdate).to eq(Date.parse(params[:birthdate]))
      end
    end
  end
end
