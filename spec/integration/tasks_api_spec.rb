# spec/integration/tasks_api_spec.rb
require 'swagger_helper'

describe 'Tasks API' do
  path '/users/{id}/tasks' do
    get 'List all tasks' do
      tags 'Tasks'
      produces 'application/json'
      security [Bearer: {}]

      response '200', 'tasks listed' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              description: { type: :string },
              due_date: { type: :string, format: :date },
              priorities: { type: :string },
              status: { type: :string },
              image: { type: :string }
            },
            required: [ 'id', 'title', 'description', 'due_date', 'priorities', 'status', 'image' ]
          }
        run_test!
      end
    end

    post 'Create a task' do
      tags 'Tasks'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          due_date: { type: :string, format: :date },
          priorities: { type: :string },
          status: { type: :string },
          image: { type: :string }
        },
        required: [ 'title', 'description', 'due_date', 'priorities', 'status', 'image' ]
      }

      response '201', 'task created' do
        let(:task) { { title: 'Sample Task', description: 'Task description', due_date: '2023-12-31', priorities: 'High', status: 'Pending', image: 'http://example.com/image.jpg' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:task) { { title: 'Invalid Task' } }
        run_test!
      end
    end
  end

  path '/users/{id}/tasks/{id}' do
    get 'Retrieve a task by ID' do
      tags 'Tasks'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :integer
      response '200', 'task found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            title: { type: :string },
            description: { type: :string },
            due_date: { type: :string, format: :date },
            priorities: { type: :string },
            status: { type: :string },
            image: { type: :string }
          },
          required: [ 'id', 'title', 'description', 'due_date', 'priorities', 'status', 'image' ]

        let(:id) { Task.create(title: 'Sample Task', description: 'Task description', due_date: '2023-12-31', priorities: 'High', status: 'Pending', image: 'http://example.com/image.jpg').id }
        run_test!
      end

      response '404', 'task not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    patch 'Update a task by ID' do
      tags 'Tasks'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :integer
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          due_date: { type: :string, format: :date },
          priorities: { type: :string },
          status: { type: :string },
          image: { type: :string }
        }
      }

      response '200', 'task updated' do
        let(:id) { Task.create(title: 'Sample Task', description: 'Task description', due_date: '2023-12-31', priorities: 'High', status: 'Pending', image: 'http://example.com/image.jpg').id }
        let(:task) { { title: 'Updated Task' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { 'invalid' }
        let(:task) { { title: '' } }
        run_test!
      end
    end

    delete 'Delete a task by ID' do
      tags 'Tasks'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :integer

      response '200', 'task deleted' do
        let(:id) { Task.create(title: 'Sample Task', description: 'Task description', due_date: '2023-12-31', priorities: 'High', status: 'Pending', image: 'http://example.com/image.jpg').id }
        run_test!
      end

      response '404', 'task not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

describe 'Tasks Assign API' do
  path '/task/assign' do
    post 'Assign a task to a user' do
      tags 'Tasks'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :task_id, in: :query, type: :integer
      parameter name: :user_id, in: :query, type: :integer

      response '200', 'task assigned' do
        let(:task_id) { Task.create(title: 'Sample Task', description: 'Task description', due_date: '2023-12-31', priorities: 'High', status: 'Pending', image: 'http://example.com/image.jpg').id }
        let(:user_id) { User.create(name: 'John Doe', email: 'john@example.com', password: 'password', user_type: 'User').id }
        before do
          allow(MyMailer).to receive_message_chain(:with, :welcome_email, :deliver_now)
        end
        let(:user_task) { User.find_by_id(user_id).tasks << Task.find_by_id(task_id) }
        run_test!
      end
    end
  end
end

end
