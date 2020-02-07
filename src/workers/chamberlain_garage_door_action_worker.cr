require "sidekiq/cli"
require "../libs/chamberlain"

class ChamberlainGarageDoorActionWorker
  include Sidekiq::Worker
  sidekiq_options do |job|
    job.queue = "default"
    job.retry = false
  end

  def perform(device_id : Int64, action : String)
    if device = Device.find(device_id)
      if remote_credential = device.try &.remote_credential
        auth = ::Chamberlain::Auth.new(remote_credential.not_nil!)
        auth.login
        remote_credential.reload

        garage_doors = ::Chamberlain::GarageDoor.new(device)
        garage_doors.invoke_action(action)
      end
    end
  end
end