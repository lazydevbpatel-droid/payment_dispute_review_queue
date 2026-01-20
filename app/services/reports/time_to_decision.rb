module Reports
  class TimeToDecision
    def self.call(time_zone:)
      tz = time_zone.presence || "UTC"

      sql = <<~SQL
        WITH finalized AS (
          SELECT
            DATE_TRUNC('week', timezone('#{tz}', opened_at))::date AS week_start,
            EXTRACT(EPOCH FROM (closed_at - opened_at))::bigint AS duration_seconds
          FROM disputes
          WHERE opened_at IS NOT NULL
            AND closed_at IS NOT NULL
            AND status IN ('won', 'lost')
        )
        SELECT
          week_start,
          COUNT(*) AS sample_size,
          percentile_cont(0.50) WITHIN GROUP (ORDER BY duration_seconds) AS p50_seconds,
          percentile_cont(0.90) WITHIN GROUP (ORDER BY duration_seconds) AS p90_seconds
        FROM finalized
        GROUP BY week_start
        ORDER BY week_start ASC
      SQL

      rows = ActiveRecord::Base.connection.exec_query(sql).to_a

      rows.map do |r|
        {
          week_start: r["week_start"].to_s,
          sample_size: r["sample_size"].to_i,
          p50_seconds: r["p50_seconds"].to_f.round,
          p90_seconds: r["p90_seconds"].to_f.round
        }
      end
    end
  end
end
