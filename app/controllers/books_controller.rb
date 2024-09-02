# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: %i[show update destroy]
  before_action :validate_form, only: %i[create update]

  # GET /books
  def index
    @books = Book.includes(:author).page(page).per(per_page)

    json_response({ books: response_book_list, paginate: pagination_info(@books) }, :ok)
  end

  # GET /books/:id
  def show
    json_response(@book, :ok)
  end

  # POST /books
  def create
    @book = Book.new(book_params)
    @book.save

    json_response(@book, :created)
  rescue StandardError => e
    json_response(e, :internal_server_error)
  end

  # PATCH/PUT /books/:id
  def update
    @book.update(book_params)

    json_response(@book, :ok)
  rescue StandardError => e
    json_response(e, :internal_server_error)
  end

  # DELETE /books/:id
  def destroy
    @book.destroy

    json_response({}, :ok)
  end

  private

  def set_book
    @book = Book.find_by_id(params[:id])

    json_response({ message: 'Book not found' }, :not_found) and return unless @book.present?
  end

  def book_params
    @book_params ||= params.permit(:title, :description, :publish_date, :author_id)
  end

  def validate_form
    validate = Books::Form.new(book_params)

    json_response(validate.errors, :unprocessable_entity) and return unless validate.valid?
  end

  def response_book_list
    @books.map do |book|
      {
        id: book.id,
        title: book.title,
        description: book.description,
        publish_date: book.publish_date,
        author: {
          id: book.author.id,
          name: book.author.name
        }
      }
    end
  end
end
