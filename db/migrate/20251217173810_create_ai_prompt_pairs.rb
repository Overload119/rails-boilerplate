class CreateAIPromptPairs < ActiveRecord::Migration[8.0]
  def change
    create_table :ai_prompt_pairs do |t|
      t.string :prompt
      t.string :response
      t.integer :version
      t.string :model
      t.timestamps
    end
    add_index :ai_prompt_pairs, :version
  end
end
