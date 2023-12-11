# frozen_string_literal: true

require 'rails_helper'
include JsonWebToken
RSpec.describe TasksController, type: :controller do
  let(:admin) { FactoryBot.create(:user, user_type: 'Admin') }
  let(:manager) { FactoryBot.create(:user, user_type: 'Manager') }
  let(:user) { FactoryBot.create(:user, user_type: 'User') }
  let (:admin_task) {FactoryBot.create(:task, user_id: admin.id)}
  let!(:task) { FactoryBot.create(:task) }
  before(:each) do
    @amnin_token = jwt_encode(user_id: admin.id)
    @manager_token = jwt_encode(user_id: manager.id)
    @user_token = jwt_encode(user_id: user.id)
  end
  let(:authenticate_admin) do
    request.headers['Authorization'] = "#{@amnin_token}"
  end
  let(:authenticate_manager) do
    request.headers['Authorization'] = "#{@manager_token}"
  end
  let(:authenticate_user) do
    request.headers['Authorization'] = "#{@user_token}"
  end
  let(:result) { JSON.parse(response.body) }
  describe 'GET /index' do
    context 'when user_id present in params so show all task' do
      it 'returns task' do
        authenticate_admin
        get :index, params: { user_id: admin.id }
        expect(response.status).to eq(200)
      end
    end
    context 'when user not authorize' do
      it 'returns unauthorized' do
        get :index, params: { user_id: admin.id }
        expect(response.status).to eq(400)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid params' do
      it 'returns task' do
        authenticate_admin
        post :create,
             params: { user_id: admin.id, title: 'title', description: 'xyz', due_date: Date.today, priorities: 'high',
                       status: 'open' }
        expect(response.status).to eq(201)
      end
    end
    context 'when current user not present ' do
      it ' task not create' do
        post :create, params: { user_id: admin.id }
        expect(response.status).to eq(400)
      end
    end
  end

  describe 'PATCH /update' do
    context 'when admin update task' do
      it ' if task updates a successful' do
        authenticate_admin
        patch :update, params: { user_id: admin.id, id: admin_task.id, title: 'update task' }
        expect(result['title']).to eq('update task')
        expect(response.status).to eq(200)
      end
    end
    context 'when manager update task' do
      it ' if task updates a successful' do
        authenticate_manager
        put :update, params: { user_id: manager.id, id: admin_task.id, description: 'update description' }
        expect(result['description']).to eq('update description')
        expect(response.status).to eq(200)
      end
    end
    context 'when invalid task id present in params' do
      it 'task not find ' do
        authenticate_manager
        put :update, params: { user_id: manager.id, id: 232, status: 'open' }
        expect(result['warning']).to eq("Couldn't find Task with 'id'=232")
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'GET /show' do
    before do
      authenticate_admin
    end
    context 'When valid id present in params' do
      it 'return task' do
        get :show, params: { user_id: admin.id, id: admin_task.id }
        expect(response.status).to eq(200)
      end
    end
    context 'When invalid id present in params' do
      it 'task not find' do
        get :show, params: { user_id: admin.id, id: 343 }
        expect(result['warning']).to eq("Couldn't find Task with 'id'=343")
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when valid id presemt in params' do
      it 'return task delete' do
        authenticate_admin
        delete :destroy, params: { user_id: admin.id, id: admin_task.id }
        expect(response.status).to eq(200)
      end
    end
    context 'when invalid id presemt in params' do
      it 'return task not find' do
        authenticate_admin
        delete :destroy, params: { user_id: 23, id: 22 }
        expect(result['warning']).to eq("Couldn't find Task with 'id'=22")
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'POST /assign_task' do
    context "when manager task assign to user wiht vaiid id's" do
      it 'return task assign' do
        authenticate_manager
        post :assign_task, params: { user_id: user.id, task_id: task.id }
        expect(response.status).to eq(200)
      end
    end
    context "when manager task assign to user wiht invalid id's task" do
      it 'return task assign' do
        authenticate_manager
        post :assign_task, params: { user_id: 12, task_id: 23 }
        expect(response.status).to eq(404)
      end
    end
  end
end
