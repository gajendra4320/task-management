class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.references :user
      t.string :title
      t.text :description
      t.date :due_date
      t.string :status
      t.string :priorities

      t.timestamps
    end
  end
end
