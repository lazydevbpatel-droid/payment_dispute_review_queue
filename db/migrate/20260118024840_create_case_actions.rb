class CreateCaseActions < ActiveRecord::Migration[8.1]
  def change
    create_table :case_actions do |t|
      t.references :dispute, null: false, foreign_key: true
      t.string :actor, null: false
      t.string :action, null: false
      t.text :note
      t.jsonb :details, null: false, default: {}
      t.timestamps
    end
  end
end
