require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'Task' do
    context "association" do
      it { should belong_to(:user)}
      it { should have_many(:comments)}
    end
  end

    # context "enum" do
    #   it do
    #     should define_enum_for(:status).
    #     with_values({
    #       open: "opne",
    #       progress: "progress",
    #       closed: "closed"
    #       }).backed_by_column_of_type(:string)
    #    end
    # end

    context "validate" do
       it { should validate_presence_of(:description) }
       it { should validate_presence_of(:title) }
       it { should have_one_attached(:image) }
    end
end
