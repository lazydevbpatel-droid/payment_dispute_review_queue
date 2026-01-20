module Reports
  class DailyDisputeVolume
    def self.call(from:, to:, time_zone:)
      tz = time_zone.presence || "UTC"

      from_date = from.present? ? Date.iso8601(from.to_s) : 14.days.ago.to_date
      to_date   = to.present?   ? Date.iso8601(to.to_s)   : Date.current


      # user TZ boundaries -> convert to UTC range
      from_utc = Time.use_zone(tz) { from_date.beginning_of_day }.utc
      to_utc   = Time.use_zone(tz) { (to_date + 1).beginning_of_day }.utc # exclusive end

      # Group by day in user's timezone
      # Use opened_at for "volume" or created_at if opened_at nil; choose one consistently
      rel = Dispute
        .where(opened_at: from_utc...to_utc)
        .select(
          "DATE(timezone('#{tz}', opened_at)) AS day",
          "COUNT(*) AS dispute_count",
          "SUM(amount_cents) AS total_amount_cents"
        )
        .group("day")
        .order("day ASC")

      rel.map do |r|
        {
          day: r.day.to_s,
          dispute_count: r.dispute_count.to_i,
          total_amount_cents: r.total_amount_cents.to_i
        }
      end
    end
  end
end
