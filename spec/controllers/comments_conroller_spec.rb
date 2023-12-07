require 'rails_helper'
include JsonWebToken
RSpec.describe CommentsController, type: :controller do
  let(:admin) {FactoryBot.create(:user, user_type: "Admin")}
  let(:manager) {FactoryBot.create(:user, user_type: "Manager")}
  let(:user) {FactoryBot.create(:user, user_type: "User")}
  let(:task) {FactoryBot.create(:task)}
  let(:comment) {FactoryBot.create(:comment, user_id: user.id, task_id: task.id)}
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

  describe "GET /index" do
    context 'show all comments' do
      before do
        authenticate_user
      end
      it 'returns users' do
        get :index, params: { user_id:user.id, task_id: task.id}
        expect(response.status).to eq(200)
      end
    end
  end

  describe "POST /create" do
    before do
      authenticate_user
    end
    context 'create task' do
      it "user creates a successfuly" do
        post :create, params: {user_id: user.id, task_id:task.id, title: "nice" }
        expect(response.status).to eq(201)
        expect(result["title"]).to eq("nice")
      end
    end
  end

  describe "PATCH /update" do
    context 'update user' do
      it "user creates a successfuly" do
        authenticate_user
        patch :update, params: { id: comment.id, user_id: user.id, task_id: task.id, title:"update comment"}
        expect(result["title"]).to eq("update comment")
        expect(response.status).to eq(200)
      end
    end
  end

  describe "DELETE /destroy" do
    before do
      authenticate_user
    end
    context 'delete comment' do
      it "return comment deleted" do
        delete :destroy, params: {id:comment.id, user_id: user.id, task_id: task.id}
        expect(result["message"]).to eq("comment deleted")
        expect(response.status).to eq(200)
      end
    end
    context 'when invalid commit id present in params' do
      it "return undefine method for nill class" do
        delete :destroy, params: {id: 22, user_id: user.id, task_id: task.id}
        expect(result["warning"]).to eq("Couldn't find Comment with 'id'=22")
        expect(response.status).to eq(200)
      end
    end
  end

  describe "GET /show" do
    before do
      authenticate_user
    end
    context 'When valid comment id present in params' do
      it "return comment" do
        get :show, params: { id: comment.id, user_id:23, task_id: 34}
        expect(response.status).to eq(200)
      end
    end
    context 'When invalid comment id present in params' do
      it "return Couldn't find commet" do
        get :show, params: { id: 22, user_id: 34, task_id: 32}
        expect(result["warning"]).to eq("Couldn't find Comment with 'id'=22")
        expect(response.status).to eq(200)
      end
    end
  end





end
