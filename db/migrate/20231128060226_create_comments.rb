class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :title
      t.references :task
      t.references :user

      t.timestamps
    end
  end
end
