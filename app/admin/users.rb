# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params :name, :email, :password_digest, :user_type
  filter :email
  filter :user_type

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :password_digest
    column :user_type
    actions
  end

  form do |f|
    f.inputs 'User' do
      f.input :name
      f.input :email
      f.input :password_digest
      f.input :user_type, as: :select, collection: %w[User Admin Manager]
    end
    f.actions
  end
end
