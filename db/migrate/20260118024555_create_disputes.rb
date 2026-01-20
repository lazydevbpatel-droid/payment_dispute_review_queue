class CreateDisputes < ActiveRecord::Migration[8.1]
  def change
    create_table :disputes do |t|
      t.references :charge, null: false, foreign_key: true

      t.string  :external_id, null: false
      t.string  :status, null: false
      t.integer :amount_cents, null: false
      t.string  :currency, null: false, default: "USD"

      t.datetime :opened_at
      t.datetime :closed_at

      t.datetime :last_event_at
      t.jsonb :external_payload, null: false, default: {}

      t.timestamps
    end

    add_index :disputes, :external_id, unique: true
  end
end
