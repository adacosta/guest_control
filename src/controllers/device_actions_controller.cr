class DeviceActionsController < ApplicationController

  before_action do
    all { redirect_signed_out_user }
  end

  def create
    device = Device.find(params[:device_id])
    if device
      device.transition_door_state
      device.save
      Amber.logger.info("DeviceActionsController#create - device: #{device.inspect}")

      ChamberlainGarageDoorActionWorker.async.perform(device.id.not_nil!, params[:action].not_nil!)
      flash_message = {"success" => "Garage door #{params[:action]} command sent."}
    else
      flash_message = {"danger" => "Garage door not found!"}
    end
    redirect_back status: 302, flash: flash_message
  end
end
