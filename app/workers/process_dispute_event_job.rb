class ProcessDisputeEventJob
  include Sidekiq::Worker

  def perform(payload)
    binding.pry
    event_time = Time.iso8601(payload["occurred_at"])
    dispute_data = payload["dispute"]

    dispute = Dispute.find_or_initialize_by(
      external_id: dispute_data["external_id"]
    )

    # Ignore out-of-order events
    if dispute.last_event_at.present? && event_time <= dispute.last_event_at
      return
    end

    charge = Charge.find_or_create_by!(
      external_id: dispute_data["charge_external_id"]
    ) do |c|
      c.amount_cents = dispute_data["amount_cents"]
      c.currency = dispute_data["currency"]
    end

    dispute.assign_attributes(
      charge: charge,
      status: dispute_data["status"],
      amount_cents: dispute_data["amount_cents"] || dispute.amount_cents,
      currency: dispute_data["currency"] || dispute.currency,
      external_payload: payload,
      last_event_at: event_time
    )

    if payload["event_type"] == "dispute.opened"
      dispute.opened_at ||= event_time
    end

    if payload["event_type"] == "dispute.closed"
      dispute.closed_at = event_time
    end

    dispute.save!

    CaseAction.create!(
      dispute: dispute,
      actor: "system",
      action: payload["event_type"],
      details: payload
    )
  end
end
