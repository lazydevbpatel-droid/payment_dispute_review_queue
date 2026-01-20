class CreateEvidences < ActiveRecord::Migration[8.1]
  def change
    create_table :evidences do |t|
      t.references :dispute, null: false, foreign_key: true
      t.string :kind, null: false
      t.jsonb :metadata, null: false, default: {}
      t.timestamps
    end
  end
end
