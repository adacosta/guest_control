class DevicesFetchController < ApplicationController
  def create
    devices_fetch_params.validate!
    remote_credential = RemoteCredential.find(params["remote_credential_id"])
    if remote_credential
      ChamberlainGarageDoorFetchWorker.async.perform(remote_credential.id.not_nil!)
      redirect_to location: "/remote_credentials", status: 302, flash: {"success" => "Updating garage doors"}
    else
      redirect_to location: "/remote_credentials", status: 302, flash: {"danger" => "Remote credential not found"}
    end
  end

  private def devices_fetch_params
    params.validation do
      required(:remote_credential_id)
    end
  end
end
