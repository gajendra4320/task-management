# frozen_string_literal: true

require 'rails_helper'
include JsonWebToken
RSpec.describe UsersController, type: :controller do
  let!(:user) { FactoryBot.create(:user, user_type: 'Admin') }
  before(:each) do
    @token = jwt_encode(user_id: user.id)
  end
  let(:authenticate_user) do
    request.headers['Authorization'] = "#{@token}"
  end
  let(:result) { JSON.parse(response.body) }

  describe 'GET /index' do
    context 'show all user' do
      it 'returns users' do
        authenticate_user
        get :index
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'POST /create' do
    context 'create user' do
      it 'user creates a successfuly' do
        post :create,
             params: { name: 'rj', user_type: 'Admin', email: 'rj@gamil.com', password_digest: user.password_digest }
        expect(response.status).to eq(201)
      end
      it 'with invalid params' do
        post :create,
             params: { name: 'rj', user_type: 'Admidn', email: 'rj@gamil.com', password_digest: user.password_digest }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PATCH /update' do
    context 'update user' do
      it 'user creates a successfuly' do
        authenticate_user
        patch :update, params: { id: user.id, name: 'cafe' }
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'GET /show' do
    context 'When current user present' do
      it 'return current user' do
        authenticate_user
        get :show, params: { id: user.id }
        expect(response.status).to eq(200)
      end
    end
    context 'When current user present not present' do
      it 'return Unauthorized user' do
        get :show, params: { id: user.id }
        expect(response.status).to eq(400)
      end
    end
  end

  describe 'DELETE/destroy' do
    context 'delete current user' do
      it 'return current user delete' do
        authenticate_user
        delete :destroy, params: { id: user.id }
        expect(response.status).to eq(200)
      end
    end
    context 'when current user not present' do
      it 'return Unauthorized' do
        delete :destroy, params: { id: user.id }
        expect(response.status).to eq(400)
      end
    end
  end
end
