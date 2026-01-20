class RemoveKindFromEvidence < ActiveRecord::Migration[8.1]
  def change
    remove_column :evidences, :kind, :string
  end
end
