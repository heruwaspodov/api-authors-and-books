# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Response

  def per_page
    params[:per_page] || 10
  end

  def page
    params[:page] || 1
  end

  def pagination_info(data)
    {
      current_page: data.current_page,
      per_page: data.limit_value,
      total_entries: data.total_count,
      total_pages: data.total_pages
    }
  end
end
