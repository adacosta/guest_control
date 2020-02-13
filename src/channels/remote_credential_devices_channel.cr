class RemoteCredentialDevicesChannel < Amber::WebSockets::Channel
  def handle_joined(client_socket, message)
    # first ensure has access to this device credential
    Amber.logger.info("RemoteCredentialDevicesChannel handle_joined message = #{message}")
  end

  # Register interest in devices status by creating an async job
  #   Clients may send these very frequently - it's ok.
  #   The created job will check if devices have been updated within N seconds.
  #   If not, then the job will do the update.
  def handle_message(client_socket, message)
    Amber.logger.info("RemoteCredentialDevicesChannelhandle_message message = #{message}")
    # Amber.logger.info("client_socket = #{client_socket}")
    payload = message["payload"].as_h
    if payload && payload.has_key?("source") && payload["source"].to_s == "worker"
      Amber.logger.info("RemoteCredentialDevicesChannelhandle_message message from worker")
      # send the published message from the worker back to the clients
      # TODO: Strip the payload source before rebroadcast
      rebroadcast!(message)
    elsif payload && payload.has_key?("device_id") && payload.has_key?("action")
      Amber.logger.info("RemoteCredentialDevicesChannelhandle_message action message from client")
      if (device_id = payload["device_id"]) && (action = payload["action"])
        # TODO: Verify user has access to this device :)
        device = Device.find(device_id)
        if device
          device.advance_transition_state
          device.save

          ChamberlainGarageDoorActionWorker.async.perform(device.id.not_nil!, action.not_nil!.to_s)

          devices_message = Array(Hash(String, String | Int64)).new
          devices_message << {
            "id" => device.id.not_nil!,
            "serial_number" => device.serial_number.not_nil!,
            "online" => device.state.not_nil!["online"].to_s,
            "remote_created_at" => device.remote_created_at.not_nil!.to_s,
            "last_update" => device.state.not_nil!["last_update"].to_s,
            "last_status" => device.state.not_nil!["last_status"].to_s,
            "door_state" => device.state.not_nil!["door_state"].to_s,
            "next_state_command" => device.next_state_command.to_s
          }

          message = {
            "event"   => "message",
            "topic"   => "device_updates:remote_credential_id:#{device.try &.remote_credential.try &.id}",
            "subject" => "device_updates",
            "payload" => {
              "message" => devices_message,
              "source" => "worker",
              "content_type" => "json"
            },
          }

          rebroadcast!(message)
        end
      end
    else
      Amber.logger.info("RemoteCredentialDevicesChannel NO message from worker")
      topic_id = message["topic"].to_s.split(":").last
      ChamberlainGarageDoorFetchWorker.async.perform(topic_id.to_i64)
    end
  end

  def handle_leave(client_socket)
  end
end