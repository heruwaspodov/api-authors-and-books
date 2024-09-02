# README

This is a API for authors and books.

## Authors

* ```
  [GET] /authors
  {
    "page": 1, // number
    "per_page" : 10 // number
  }
  ```

* ```
  [POST] /authors
  {
    "name": "wspdv tampan", // string
    "bio" : "my name is waspodo" // string
    "birthdate" : "1999-12-12" // string YYYY-MM-DD
  }
  ```

* ```
  [PUT] /authors
  {
    "name": "wspdv tampan", // string
    "bio" : "my name is waspodo" // string
    "birthdate" : "1999-12-12" // string YYYY-MM-DD
  }
  ```

* ```
  [GET] /authors/:id
  ```

* ```
  [GET] /authors/:id/books
  {
    "page": 1, // number
    "per_page" : 10 // number
  }

## Book

* ```
  [GET] /books
  {
    "page": 1, // number
    "per_page" : 10 // number
  }
  ```

* ```
  [POST] /books
  {
    "title": "buku wspdv ", // string
    "description" : "penulisnya is waspodo" // string
    "publish_date" : "1999-12-12" // string YYYY-MM-DD
    "author_id" : "uuid" // string uuid
  }
  ```

* ```
  [PUT] /books
  {
    "title": "buku wspdv ", // string
    "description" : "penulisnya is waspodo" // string
    "publish_date" : "1999-12-12" // string YYYY-MM-DD
    "author_id" : "uuid" // string uuid
  }
  ```

* ```
  [GET] /books/:id
  ```


Things you may want to cover:

* Ruby version
  * 3.0.3

* Rails version
  * Rails 6.1.7.8

* System dependencies
  * rspec
  * faker
  * pg (postgresql)
  * dotenv-rails
  * kaminari

* Configuration

  Please copy `.env.example` to `.env` then configure the application for the postgesql setup.

* Database creation
  * Create the database
    ```
    rails db:create
    ```

  * Run the migration
    ```
    rails db:migration
    ```

  * Run a seeder database
    ```
    rails db:seed
    ```

* How to run the test suite
  ```
  bundle exec rspec
  ```
