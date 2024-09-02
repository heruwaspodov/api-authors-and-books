# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: %i[show update destroy]
  before_action :validate_form, only: %i[create update]

  # GET /books
  # Returns list of books with pagination
  #
  # @example
  #   GET /books
  #   {
  #     "books": [
  #       {
  #         "id": 1,
  #         "title": "My Book",
  #         "description": "This is my book",
  #         "publish_date": "1994-01-01",
  #         "author": {
  #           "id": 1,
  #           "name": "John Doe"
  #         }
  #       }
  #     ],
  #     "paginate": {
  #       "current_page": 1,
  #       "per_page": 10,
  #       "total_entries": 100,
  #       "total_pages": 10
  #     }
  #   }
  def index
    @books = Book.includes(:author).page(page).per(per_page)

    json_response({ books: response_book_list, paginate: pagination_info(@books) }, :ok)
  end

  # GET /books/:id
  #
  # Returns a single book by :id
  #
  # @example
  #   GET /books/1
  #   {
  #     "id": 1,
  #     "title": "My Book",
  #     "description": "This is my book",
  #     "publish_date": "1994-01-01",
  #     "author": {
  #       "id": 1,
  #       "name": "John Doe"
  #     }
  #   }
  #
  # The response will be cached for 1 hour
  def show
    Rails.cache.fetch("book:#{@book.id}", expires_in: 1.hours) do
      json_response(@book, :ok)
    end
  end

  # POST /books
  #
  # Creates a new book with the given parameters
  #
  # @example
  #   POST /books
  #   {
  #     "title": "My Book",
  #     "description": "This is my book",
  #     "publish_date": "1994-01-01",
  #     "author_id": 1
  #   }
  #
  # The response will be cached for 1 hour
  #
  # @param [Hash] book_params The parameters to create the book
  def create
    @book = Book.new(book_params)
    @book.save

    json_response(@book, :created)
  rescue StandardError => e
    json_response(e, :internal_server_error)
  end

  # PATCH/PUT /books/:id
  #
  # Updates the book with the given parameters
  #
  # @example
  #   PATCH /books/1
  #   {
  #     "title": "My Book",
  #     "description": "This is my book",
  #     "publish_date": "1994-01-01",
  #     "author_id": 1
  #   }
  #
  # The response will be cached for 1 hour
  #
  # @param [Hash] book_params The parameters to update the book
  def update
    @book.update(book_params)

    json_response(@book, :ok)
  rescue StandardError => e
    json_response(e, :internal_server_error)
  end

  # DELETE /books/:id
  #
  # Deletes the book with the given :id
  #
  # @example
  #   DELETE /books/1
  #
  # The response will be cached for 1 hour
  def destroy
    # Destroy the book
    @book.destroy

    # Return an empty JSON response with HTTP status :ok
    json_response({}, :ok)
  end

  private

  # Finds the book with the given :id
  #
  # @example
  #   GET /books/1
  #
  # The response will be cached for 1 hour
  def set_book
    # Find the book with the given :id
    @book = Book.find_by_id(params[:id])

    # If the book is not found, return an empty JSON response with HTTP status :not_found
    json_response({ message: 'Book not found' }, :not_found) and return unless @book.present?
  end

  # The parameters that are permitted for the book
  #
  # @return [ActionController::Parameters] The permitted parameters
  def book_params
    @book_params ||= params.permit(:title, :description, :publish_date, :author_id)
  end

  # Validates the book form
  #
  # @example
  #   POST /books
  #   {
  #     "book": {
  #       "title": "The Great Gatsby",
  #       "description": "The Great Gatsby is a novel by F. Scott Fitzgerald",
  #       "publish_date": "1925-04-10",
  #       "author_id": 1
  #     }
  #   }
  #
  # The response will be cached for 1 hour
  def validate_form
    # Create a Books::Form object
    validate = Books::Form.new(book_params)

    # If the form is not valid, return an empty JSON response with HTTP status :unprocessable_entity
    json_response(validate.errors, :unprocessable_entity) and return unless validate.valid?
  end

  # The list of books with pagination
  #
  # @return [Array<Hash>] The list of books with pagination
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
