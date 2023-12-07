# spec/integration/users_api_spec.rb
require 'swagger_helper'

describe 'Users API' do

  path '/users' do
    get 'List all users' do
      tags 'Users'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer

      response '200', 'users listed' do
        schema type: :object,
          properties: {
            users: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  email: { type: :string },
                  user_type: { type: :string }
                }
              }
            },
            meta: {
              type: :object,
              properties: {
                current_page: { type: :integer },
                total_page: { type: :integer }
              }
            }
          }

        let(:page) { 1 }
        run_test!
      end
    end

    post 'Create a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          password_digest: { type: :string },
          user_type: { type: :string }
        },
        required: [ 'name', 'email', 'password_digest', 'user_type' ]
      }

      response '201', 'user created' do
        let(:user) { { name: 'John Doe', email: 'john@example.com', password_digest: 'password', user_type: 'Admin' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { name: 'John Doe' } }
        run_test!
      end
    end
  end

  path '/users/{id}' do
    get 'Retrieve a user by ID' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'user found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            email: { type: :string },
            user_type: { type: :string }
          },
          required: [ 'id', 'name', 'email', 'user_type' ]

        let(:id) { User.create(name: 'John Doe', email: 'john@example.com', password_digest: 'password', user_type: 'Admin').id }
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/users/update' do
    patch 'Update the current user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          password_digest: { type: :string },
          user_type: { type: :string }
        }
      }

      response '200', 'user updated' do
        let(:user) { { name: 'Updated Name' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { email: '' } }
        run_test!
      end
    end
  end

  path '/users/show' do
    get 'Retrieve the current user' do
      tags 'Users'
      produces 'application/json'

      response '200', 'user found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            email: { type: :string },
            user_type: { type: :string }
          },
          required: [ 'id', 'name', 'email', 'user_type' ]

        run_test!
      end
    end
  end
end
