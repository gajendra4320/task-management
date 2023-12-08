  require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'User' do
    context "association" do
      it { should have_many(:tasks)}
      it { should have_many(:comments)}

    end
  end

    # context "enum" do
    #   it do
    #     should define_enum_for(:user_type).
    #     with_values(
    #       User:"User",
    #       Asmin: "Admin",
    #       Manager: "Manager"
    #       ).
    #     backed_by_column_of_type(:string)
    #    end
    # end

    context "validate" do
       it { should validate_presence_of(:email) }
       it { should validate_inclusion_of(:user_type).in_array(["Admin","User", "Manager"])}
    end
end
