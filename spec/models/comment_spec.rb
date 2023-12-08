require 'rails_helper'
RSpec.describe Comment, type: :model do
  describe 'Comment' do
    context "association" do
      it { should belong_to(:user)}
      it { should belong_to(:task)}
    end
  end
end
