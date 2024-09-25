FactoryBot.define do
  factory(:data_migration) do
    model { :academic_year }
    worker { 0 }
    processed_count { 0 }
    failure_count { 0 }
    queued_at { 2.minutes.ago }
    total_count { nil }
    started_at { nil }
    completed_at { nil }
  end
end
