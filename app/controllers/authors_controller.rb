# frozen_string_literal: true

class AuthorsController < ApplicationController
  before_action :set_author, only: %i[show update destroy books]
  before_action :validate_form, only: %i[create update]

  # GET /authors
  # Returns list of authors with pagination information
  #
  # @example Response
  #   {
  #     "authors": [
  #       {
  #         "id": "uuid",
  #         "name": "string",
  #         "bio": "string",
  #         "birthdate": "date",
  #         "created_at": "datetime",
  #         "updated_at": "datetime"
  #       }
  #     ],
  #     "paginate": {
  #       "current_page": number,
  #       "per_page": number,
  #       "total_entries": number,
  #       "total_pages": number
  #     }
  #   }
  #
  # @return [JSON] response with list of authors and pagination information
  def index
    @authors = Author.includes(:books).page(page).per(per_page)

    json_response({ authors: @authors, paginate: pagination_info(@authors) }, :ok)
  end

  # GET /authors/:id
  #
  # Returns a specific author
  #
  # @example Response
  #   {
  #     "id": "uuid",
  #     "name": "string",
  #     "bio": "string",
  #     "birthdate": "date",
  #     "created_at": "datetime",
  #     "updated_at": "datetime"
  #   }
  #
  # @param id [String] uuid of the author
  # @return [JSON] response with the author
  def show
    Rails.cache.fetch("author:#{@author.id}", expires_in: 1.hours) do
      json_response(@author, :ok)
    end
  end

  # POST /authors
  #
  # Creates a new author
  #
  # @example Request body
  #   {
  #     "name": "string",
  #     "bio": "string",
  #     "birthdate": "date"
  #   }
  #
  # @example Response
  #   {
  #     "id": "uuid",
  #     "name": "string",
  #     "bio": "string",
  #     "birthdate": "date",
  #     "created_at": "datetime",
  #     "updated_at": "datetime"
  #   }
  #
  # @param [Hash] author_params The parameters for the new author
  # @return [JSON] response with the created author
  def create
    @author = Author.new(author_params)
    @author.save

    json_response(@author, :created)
  rescue StandardError => e
    json_response(e, :internal_server_error)
  end

  # PATCH/PUT /authors/:id
  #
  # Updates an existing author
  #
  # @example Request body
  #   {
  #     "name": "string",
  #     "bio": "string",
  #     "birthdate": "date"
  #   }
  #
  # @example Response
  #   {
  #     "id": "uuid",
  #     "name": "string",
  #     "bio": "string",
  #     "birthdate": "date",
  #     "created_at": "datetime",
  #     "updated_at": "datetime"
  #   }
  #
  # @param [Hash] author_params The parameters for the updated author
  # @return [JSON] response with the updated author
  def update
    @author.update(author_params)

    json_response(@author, :ok)
  rescue StandardError => e
    json_response(e, :internal_server_error)
  end

  # DELETE /authors/:id
  #
  # Deletes an existing author
  #
  # @return [JSON] response with empty body
  def destroy
    @author.destroy

    json_response({}, :ok)
  end

  # GET /authors/:id/books
  #
  # Returns a list of books that are associated to the author
  #
  # @example Request
  #   GET /authors/:id/books?page=1&per_page=10
  #
  # @example Response
  #   {
  #     "books": [
  #       {
  #         "id": "uuid",
  #         "title": "string",
  #         "description": "string",
  #         "publish_date": "date"
  #       }
  #     ],
  #     "paginate": {
  #       "current_page": number,
  #       "per_page": number,
  #       "total_entries": number,
  #       "total_pages": number
  #     }
  #   }
  #
  # @param [Hash] params The parameters that are passed to the action
  # @return [JSON] response with a list of books that are associated to the author
  #   and pagination information
  def books
    @books = @author.books.page(page).per(per_page)

    json_response({ books: response_book_list, paginate: pagination_info(@books) }, :ok)
  end

  private

  # Finds the author by id param
  #
  # @return [Author] the requested author
  # @raise [JSON] with status :not_found if the author is not found
  def set_author
    @author = Author.find_by_id(params[:id])

    json_response({ message: 'Author not found' }, :not_found) and return unless @author.present?
  end

  # @return [Hash] params for the author
  #
  # @api private
  def author_params
    @author_params ||= params.permit(:name, :bio, :birthdate)
  end

  # Validates the form params
  #
  # @return [JSON] response with empty body or
  #   with status :unprocessable_entity if the form is invalid
  def validate_form
    # Validates the form params
    validate = Authors::Form.new(author_params)

    # If the form is invalid, returns the errors
    # in a JSON response with status :unprocessable_entity
    json_response(validate.errors, :unprocessable_entity) and return unless validate.valid?
  end

  # Returns the list of books in a format
  # that is suitable to be converted to JSON
  #
  # @return [Array<Hash>] the list of books in a format
  #   that is suitable to be converted to JSON
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
