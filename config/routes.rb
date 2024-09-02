# frozen_string_literal: true

Rails.application.routes.draw do
  resources :authors, except: %i[new edit]
  get 'authors/:id/books', to: 'authors#books', as: :author_books

  resources :books, except: %i[new edit]
end
