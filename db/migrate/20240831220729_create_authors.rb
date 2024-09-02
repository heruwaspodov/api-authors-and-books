# frozen_string_literal: true

class CreateAuthors < ActiveRecord::Migration[6.1]
  def change
    create_table :authors, id: :uuid do |t|
      t.string :name
      t.string :bio
      t.date :birthdate
      t.timestamps
    end
  end
end
