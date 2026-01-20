class CreateAdjustments < ActiveRecord::Migration[8.1]
  def change
    create_table :adjustments do |t|
      t.references :dispute, null: false, foreign_key: true
      t.integer :amount_cents, null: false
      t.string :currency, null: false, default: "USD"
      t.string :reason, null: false
      t.timestamps
    end
  end
end
