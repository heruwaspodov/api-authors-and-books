# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create Author', type: :request do
  let(:endpoint) { authors_path }

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

  describe 'POST /authors' do
    context 'without params' do
      it 'should returns unprocessable_entity' do
        post endpoint, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'should returns errors validation' do
        post endpoint, headers: headers

        body = JSON.parse(response.body)

        expect(body['data']['name'].include?('can\'t be blank')).to be_truthy
        expect(body['data']['bio'].include?('can\'t be blank')).to be_truthy
        expect(body['data']['birthdate'].include?('can\'t be blank')).to be_truthy
        expect(body['data']['birthdate'].include?('Invalid date format')).to be_truthy
      end
    end

    context 'with valid params' do
      it 'should returns created http status' do
        post endpoint, headers: headers, params: params

        expect(response).to have_http_status(:created)
      end

      it 'should save record' do
        expect(Author.count).to eq(0)

        post endpoint, headers: headers, params: params

        expect(Author.count).to eq(1)
      end

      it 'should save record with valid params' do
        post endpoint, headers: headers, params: params

        author = Author.first

        expect(author.name).to eq(params[:name])
        expect(author.bio).to eq(params[:bio])
        expect(author.birthdate).to eq(Date.parse(params[:birthdate]))
      end
    end
  end
end
