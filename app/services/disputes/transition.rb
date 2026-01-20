# frozen_string_literal: true

module Disputes
  class Transition
    ALLOWED = {
      "open" => %w[needs_evidence awaiting_decision],
      "needs_evidence" => %w[awaiting_decision],
      "awaiting_decision" => %w[won lost],
      "won" => [],
      "lost" => []
    }.freeze

    def self.call!(dispute:, actor:, to:, note:)
      from = dispute.status.to_s
      to = to.to_s

      raise ArgumentError, "Invalid target status" if to.blank?
      raise ArgumentError, "Transition not allowed: #{from} → #{to}" unless ALLOWED.fetch(from, []).include?(to)

      Dispute.transaction do
        dispute.status = to
        dispute.closed_at = Time.current if %w[won lost].include?(to)
        dispute.save!

        CaseAction.create!(
          dispute: dispute,
          actor: actor.email,
          action: "status_changed",
          note: note.presence,
          details: { from: from, to: to }
        )

        # inside Disputes::Transition.call!
        if %w[won lost].include?(to)
          amount =
            to == "won" ? dispute.amount_cents : -dispute.amount_cents

          dispute.adjustment&.destroy # in case of re-decision

          Adjustment.create!(
            dispute: dispute,
            amount_cents: amount,
            currency: dispute.currency,
            reason: "dispute_#{to}"
          )
        end
      end
    end
  end
end
