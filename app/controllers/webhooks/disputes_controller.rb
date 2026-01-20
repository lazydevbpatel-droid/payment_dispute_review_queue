class Webhooks::DisputesController < ActionController::API
  before_action :verify_signature!

  def create
    ::ProcessDisputeEventJob.perform_async(permitted_payload)
    head :accepted
  end

  private

  def permitted_payload
    params.except(:controller, :action).permit!.to_hash.deep_stringify_keys
  end

  def verify_signature!
    payload   = request.raw_post
    timestamp = request.headers["HTTP_X_TIMESTAMP"]&.strip
    signature = request.headers["HTTP_X_SIGNATURE"]&.strip

    return head :unauthorized if payload.blank? || timestamp.blank? || signature.blank?

    secret = ENV.fetch("WEBHOOK_SECRET")

    signed_payload = "#{timestamp}.#{payload}"

    expected_signature = OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new("sha256"),
      secret,
      signed_payload
    )
    unless ActiveSupport::SecurityUtils.secure_compare(expected_signature, signature)
      Rails.logger.warn "Webhook signature mismatch"
      head :unauthorized
    end
  end
end
