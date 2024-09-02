# frozen_string_literal: true

module Response
  def json_response(object, status)
    render json: {
      data: object
    }, status: status
  end
end
