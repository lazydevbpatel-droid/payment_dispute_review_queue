class Dispute < ApplicationRecord
    belongs_to :charge

    has_many :case_actions, dependent: :destroy
    has_many :evidence, dependent: :destroy
    has_one :adjustment, dependent: :destroy

    STATUSES = %w[
        open
        needs_evidence
        awaiting_decision
        won
        lost
    ].freeze

    validates :external_id, presence: true, uniqueness: true
    validates :status, inclusion: { in: STATUSES }
end
