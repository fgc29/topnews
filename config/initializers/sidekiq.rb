require 'sidekiq'
require 'sidekiq-scheduler'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }

  config.on(:startup) do
    Sidekiq.schedule = {
      'fetch_news_stories' => {
        'every' => ENV.fetch('POLLING_INTERVAL', '3m'),
        'class' => 'FetchNewsStoriesJob'
      }
    }
    SidekiqScheduler::Scheduler.instance.reload_schedule!
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
end