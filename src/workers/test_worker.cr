require "sidekiq/cli"

class TestWorker
  include Sidekiq::Worker
  sidekiq_options do |job|
    job.queue = "default"
    job.retry = true
  end

  def perform(x : Int64)
    logger.info "hello!"
  end
end