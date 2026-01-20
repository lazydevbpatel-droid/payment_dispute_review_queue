# lib/tasks/webhook_test.rake
require 'openssl'
require 'securerandom'

namespace :webhook do
  task sign: :environment do
    dispute_id = SecureRandom.hex(8)
    payload = JSON.generate({ "event_type": "dispute.opened","occurred_at": "2026-01-15T10:00:00Z","dispute": {"external_id": dispute_id,"charge_external_id": "charge_123","amount_cents": 10000,"currency": "USD","status": "open"}})

    ts = Time.now.to_i.to_s
    secret = ENV["WEBHOOK_SECRET"]

    if secret.nil? || secret.empty?
      abort "WEBHOOK_SECRET environment variable is not set"
    end
    puts "timestamp: #{ts}"
    puts "dispute_id: #{dispute_id}"
    puts OpenSSL::HMAC.hexdigest("SHA256", secret, "#{ts}.#{payload}")
    puts "payload: #{payload}"
  end
end
