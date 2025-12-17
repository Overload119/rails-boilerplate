# typed: false
# frozen_string_literal: true

require "sidekiq"
require "sidekiq-cron"
require "sidekiq-unique-jobs"

# Configure Redis connection
redis_config = {
  url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"),
}

Sidekiq.configure_server do |config|
  config.redis = redis_config

  # Enable unique jobs
  config.client_middleware do |chain|
    chain.add(SidekiqUniqueJobs::Middleware::Client)
  end

  config.server_middleware do |chain|
    chain.add(SidekiqUniqueJobs::Middleware::Server)
  end

  SidekiqUniqueJobs::Server.configure(config)

  # Load cron jobs from schedule file if it exists
  schedule_file = Rails.root.join("config/sidekiq_schedule.yml")
  if File.exist?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash(YAML.load_file(schedule_file))
  end
end

Sidekiq.configure_client do |config|
  config.redis = redis_config

  config.client_middleware do |chain|
    chain.add(SidekiqUniqueJobs::Middleware::Client)
  end
end
