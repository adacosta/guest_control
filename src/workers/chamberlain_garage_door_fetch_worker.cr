require "sidekiq/cli"
require "../libs/chamberlain"

class ChamberlainGarageDoorFetchWorker
  QUEUE = "default"
  LOGIN_TIMEOUT = 10.minutes

  include Sidekiq::Worker
  sidekiq_options do |job|
    job.queue = QUEUE
    job.retry = false
  end

  def perform(remote_credential_id : Int64)
    if remote_credential = RemoteCredential.find(remote_credential_id)
      if last_auth_request = remote_credential.last_auth_request_at
        if (last_auth_request + LOGIN_TIMEOUT) < Time.utc
          remote_credential = update_credential(remote_credential)
        else
          Amber.logger.info("ChamberlainGarageDoorFetchWorker#perform - Remote credential update not needed.")
        end
      else
        remote_credential = update_credential(remote_credential)
      end
      garage_doors = ::Chamberlain::GarageDoors.new(remote_credential.not_nil!)
      devices = garage_doors.fetch

      devices_message = Array(Hash(String, String | Int64)).new
      redis = Redis::PooledClient.new(url: Amber.settings.redis_url)

      devices.each do |device|

        # when state command is issued, it can take the remote a little while to update and return the new state
        # give a 2 second break on open to update the door state from the transition state
        # give a 12 second break on close because the door has to flash and beep for a while
        door_state = device.state.not_nil!["door_state"].to_s
        if ((transition_state = device.transition_state) && (transition_state_at = device.transition_state_at))
          action_update_delay = 2.seconds
          if transition_state == "closing"
            action_update_delay = 10.seconds
          end
          Amber.logger.info("Using delay #{action_update_delay}")

          if transition_state_at > (Time.utc - action_update_delay)
            Amber.logger.info("transition state is newer, using it for door state")
            Amber.logger.info("current state is #{door_state}; returning update state as #{transition_state}")
            door_state = transition_state
          else
            # clear the transition state values (outside of windows)
            Amber.logger.info("clearing transition state values")
            device.update(transition_state: nil, transition_state_at: nil)
          end
        end

        device_message_item = {
          "id" => device.id.not_nil!,
          "serial_number" => device.serial_number.not_nil!,
          "online" => device.state.not_nil!["online"].to_s,
          "remote_created_at" => device.remote_created_at.not_nil!.to_s,
          "last_update" => device.state.not_nil!["last_update"].to_s,
          "last_status" => device.state.not_nil!["last_status"].to_s,
          "door_state" => door_state,
          "next_state_command" => device.next_state_command.to_s
        }
        devices_message << device_message_item

        # publish a message per device for single device subscribers (guests)
        message = {
          "event"   => "message",
          "topic"   => "device_updates:device_id:#{device.id.not_nil!}",
          "subject" => "device_updates",
          "payload" => {
            "message" => device_message_item,
            "source" => "worker",
            "content_type" => "json"
          },
        }

        # redis = Redis.new(url: Amber.settings.redis_url)
        redis.publish("device_updates:device_id", {sender: "76cfe330-cdb0-4850-a250-7326b1ef0000", msg: message}.to_json)
        Amber.logger.info("Published device update from worker!")
      end

      # publish all devices
      message = {
        "event"   => "message",
        "topic"   => "device_updates:remote_credential_id:#{remote_credential_id}",
        "subject" => "device_updates",
        "payload" => {
          "message" => devices_message,
          "source" => "worker",
          "content_type" => "json"
        },
      }

      # redis = Redis.new(url: Amber.settings.redis_url)
      redis.publish("device_updates:remote_credential_id", {sender: "76cfe330-cdb0-4850-a250-7326b1ef0000", msg: message}.to_json)
      Amber.logger.info("Published all devices from worker!")
    end
  end

  def perform_unique(remote_credential_id : Int64)
    # key = "#{action}:#{model_name}:#{id}"
    # queue = Sidekiq::Queue.new('elasticsearch')
    # queue.each { |q| return if q.args.join(':') == key }
    # Indexer.perform_async(action, model_name, id)
  end

  private def update_credential(remote_credential) : RemoteCredential
    Amber.logger.info("ChamberlainGarageDoorFetchWorker#perform - Updating remote credential.")
    auth = ::Chamberlain::Auth.new(remote_credential.not_nil!)
    remote_credential = auth.login
    remote_credential
  end
end