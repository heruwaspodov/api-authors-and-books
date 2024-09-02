# frozen_string_literal: true

class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books, id: :uuid do |t|
      t.string :title
      t.string :description
      t.date :publish_date
      t.references :author, null: false, foreign_key: { to_table: :authors }, type: :uuid
      t.timestamps
    end
  end
end
