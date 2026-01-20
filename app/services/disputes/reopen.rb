# frozen_string_literal: true

module Disputes
  class Reopen
    def self.call!(dispute:, actor:, note:)
      raise ArgumentError, "Reopen note is required" if note.strip.empty?
      raise ArgumentError, "Only won/lost disputes can be reopened" unless %w[won lost].include?(dispute.status)

      Dispute.transaction do
        from = dispute.status
        dispute.status = "open"
        dispute.closed_at = nil
        dispute.save!

        CaseAction.create!(
          dispute: dispute,
          actor: actor.email,
          action: "reopened",
          note: note,
          details: { from: from, to: "open" }
        )
      end
    end
  end
end
