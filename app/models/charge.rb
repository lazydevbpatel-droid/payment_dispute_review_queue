class Charge < ApplicationRecord
    has_many :disputes, dependent: :restrict_with_exception
    validates :external_id, presence: true, uniqueness: true
end
