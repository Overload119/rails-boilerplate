# frozen_string_literal: true

class CreateTodos < ActiveRecord::Migration[8.0]
  def change
    create_table(:todos) do |t|
      t.string(:title, null: false)
      t.boolean(:completed, default: false, null: false)
      t.integer(:position, null: false)

      t.timestamps
    end

    add_index(:todos, :position)
    add_index(:todos, :completed)
  end
end
