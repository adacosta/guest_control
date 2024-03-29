class DevicesChannel < Amber::WebSockets::Channel
  def handle_joined(client_socket, message)
    # first ensure has access to this device credential
    Amber.logger.info("DevicesChannel handle_joined message = #{message}")
  end

  def handle_message(client_socket, message)
    Amber.logger.info("DevicesChannel handle_message message = #{message}")
    # Amber.logger.info("client_socket = #{client_socket}")
    payload = message["payload"].as_h
    if payload && payload.has_key?("source") && payload["source"].to_s == "worker"
      Amber.logger.info("DevicesChannel message from worker")
      # send the published message from the worker back to the clients
      # TODO: Strip the payload source before rebroadcast
      rebroadcast!(message)
    elsif payload && payload.has_key?("device_id") && payload.has_key?("action")
      Amber.logger.info("DevicesChannel action message from client")
      if (device_id = payload["device_id"]) && (action = payload["action"])
        # TODO: Verify user has access to this device :)
        device = Device.find(device_id)
        if device
          Amber.logger.info("ddevice currently: #{device.inspect}")
          device.advance_transition_state
          device.save
          Amber.logger.info("device after transition: #{device.inspect}")

          ChamberlainGarageDoorActionWorker.async.perform(device.id.not_nil!, action.not_nil!.to_s)

          devices_message_item = Hash(String, String | Int64).new
          devices_message_item = {
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
            "topic"   => "device_updates:#{device.id.not_nil!}",
            "subject" => "device_updates",
            "payload" => {
              "message" => devices_message_item,
              "source" => "worker",
              "content_type" => "json"
            },
          }

          rebroadcast!(message)
        end
      end
    else
      Amber.logger.info("DevicesChannel NO message from worker")
      topic_id = message["topic"].to_s.split(":").last
      if topic_id
        if device = Device.find(topic_id)
          if remote_credential_id = device.remote_credential_id
            # if device updated not updated within N seconds, request the fetch
            if (device.updated_at && device.updated_at.not_nil! < Time.utc - 2.seconds) || device.updated_at.nil?
            # ensure request for device also hasn't been made
              requests_count = Request.
                where { sql("created_at > (NOW()+ '2 seconds'::interval)") & (_remote_credential_id == remote_credential_id) }.
                count
              if requests_count && requests_count == 0
                ChamberlainGarageDoorFetchWorker.async.perform(remote_credential_id.to_i64)
              else
                Amber.logger.info("Skipping door fetch request (too recent); request_count = #{requests_count.to_s}")
              end
            end
          end
        end
      end
    end
  end

  def handle_leave(client_socket)
  end
end