class Adjustment < ApplicationRecord
    belongs_to :dispute

    validates :amount_cents, presence: true
end
