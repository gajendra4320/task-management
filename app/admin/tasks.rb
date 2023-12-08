# frozen_string_literal: true

ActiveAdmin.register Task do
  permit_params :user_id, :title, :description, :due_date, :status, :priorities, :image

  index do
    selectable_column
    id_column
    column :user_id
    column :image do |task|
      if task.image.attached?
        image_tag task.image, size: '50x50'
      else
        'No Image'
      end
    end
    column :title
    column :description
    column :due_date
    column :status
    column :priorities
    actions
  end

  filter :user_id
  filter :title
  filter :due_date
  filter :status
  filter :priorities

  form do |f|
    f.inputs 'Task Details' do
      f.input :user_id
      f.input :image, as: :file
      f.input :title
      f.input :description
      f.input :due_date, as: :datepicker
      f.input :status
      f.input :priorities
    end
    f.actions
  end
end
