class CaseAction < ApplicationRecord
    belongs_to :dispute

    validates :actor, :action, presence: true
end
