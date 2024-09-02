# frozen_string_literal: true

class AuthorsController < ApplicationController
  before_action :set_author, only: %i[show update destroy books]
  before_action :validate_form, only: %i[create update]

  # GET /authors
  def index
    @authors = Author.includes(:books).page(page).per(per_page)

    json_response({ authors: @authors, paginate: pagination_info(@authors) }, :ok)
  end

  # GET /authors/:id
  def show
    Rails.cache.fetch("author:#{@author.id}", expires_in: 1.hours) do
      json_response(@author, :ok)
    end
  end

  # POST /authors
  def create
    @author = Author.new(author_params)
    @author.save

    json_response(@author, :created)
  rescue StandardError => e
    json_response(e, :internal_server_error)
  end

  # PATCH/PUT /authors/:id
  def update
    @author.update(author_params)

    json_response(@author, :ok)
  rescue StandardError => e
    json_response(e, :internal_server_error)
  end

  # DELETE /authors/:id
  def destroy
    @author.destroy

    json_response({}, :ok)
  end

  # GET /authors/:id/books
  def books
    @books = @author.books.page(page).per(per_page)

    json_response({ books: response_book_list, paginate: pagination_info(@books) }, :ok)
  end

  private

  def set_author
    @author = Author.find_by_id(params[:id])

    json_response({ message: 'Author not found' }, :not_found) and return unless @author.present?
  end

  def author_params
    @author_params ||= params.permit(:name, :bio, :birthdate)
  end

  def validate_form
    validate = Authors::Form.new(author_params)

    json_response(validate.errors, :unprocessable_entity) and return unless validate.valid?
  end

  def response_book_list
    @books.map do |book|
      {
        id: book.id,
        title: book.title,
        description: book.description,
        publish_date: book.publish_date
      }
    end
  end
end
