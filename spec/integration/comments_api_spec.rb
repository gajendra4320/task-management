require 'swagger_helper'

describe 'Comments API' do
  path '/users/{id}/tasks/{id}/comments' do
    post 'Creates a comment' do
      tags 'Comments'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :title, in: :query, type: :string
      parameter name: :task_id, in: :query, type: :integer
      parameter name: :user_id, in: :query, type: :integer


      response '201', 'comment created' do
        let(:title) { 'Example Comment' }
        let(:task_id) { Task.create(title: 'Sample Task').id }
        before do
          allow(MyMailer).to receive_message_chain(:with, :comments_on_task, :deliver_now)
        end
        run_test!
      end

      response '422', 'invalid request' do
        let(:title) { '' }
        let(:task_id) { '' }
        run_test!
      end
    end

    get 'Retrieves all comments' do
      tags 'Comments'
      produces 'application/json'
      security [Bearer: {}]
      response '200', 'comments found' do
        let(:comments) { Comment.create(title: 'Example Comment', task_id: Task.create(title: 'Sample Task').id, user_id: User.create(name: 'John Doe', email: 'john@example.com', password_digest: 'password', user_type: 'Admin').id )}
        run_test!
      end
    end
  end

  path '/users/{id}/tasks/{id}/comments/{id}' do
    get 'Retrieves a comment by ID' do
      tags 'Comments'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :integer

      response '200', 'comment found' do
        let(:id) { Comment.create(title: 'Example Comment', task_id: Task.create(title: 'Sample Task').id).id }
        run_test!
      end

      response '404', 'comment not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a comment' do
      tags 'Comments'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :integer
      parameter name: :title, in: :query, type: :string
      parameter name: :task_id, in: :query, type: :integer
      parameter name: :user_id, in: :query, type: :integer

      response '200', 'comment updated' do
        let(:id) { Comment.create(title: 'Example Comment', task_id: Task.create(title: 'Sample Task').id).id }
        let(:title) { 'Updated Comment' }
        let(:task_id) { Task.create(title: 'Updated Task').id }
        let(:id) { User.create(name: 'John Doe', email: 'john@example.com', password_digest: 'password', user_type: 'Admin').id }
        run_test!
      end

      response '404', 'comment not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    delete 'Deletes a comment' do
      tags 'Comments'
      parameter name: :id, in: :path, type: :integer
      response '200', 'comment deleted' do
        let(:id) { Comment.create(title: 'Example Comment', task_id: Task.create(title: 'Sample Task').id).id }
        run_test!
      end

      response '404', 'comment not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
