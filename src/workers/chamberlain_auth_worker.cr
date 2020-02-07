require "sidekiq/cli"
require "../libs/chamberlain"

class ChamberlainAuthWorker
  include Sidekiq::Worker
  sidekiq_options do |job|
    job.queue = "default"
    job.retry = false
  end

  def perform(remote_credential_id : Int64)
    if remote_credential = RemoteCredential.find(remote_credential_id)
      auth = ::Chamberlain::Auth.new(remote_credential.not_nil!)
      auth.login
      remote_credential.reload
      unless remote_credential.chamberlain_account_id
        account = ::Chamberlain::Account.new(remote_credential.not_nil!)
        account.fetch
        garage_doors = ::Chamberlain::GarageDoors.new(remote_credential.not_nil!)
        garage_doors.fetch
      end
    end
  end
end