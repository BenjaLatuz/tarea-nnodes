require 'sidekiq'
require 'sidekiq-scheduler'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
  
  # Configuración del scheduler
  config.on(:startup) do
    Sidekiq.schedule = {
      'generate_round' => {
        'every' => ['3m', { first_in: '3m' }],  # Cada 3 minutos, empezando 3 minutos después de iniciar
        'class' => 'GenerateRoundJob'
      }
    }
    SidekiqScheduler::Scheduler.instance.reload_schedule!
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
end 