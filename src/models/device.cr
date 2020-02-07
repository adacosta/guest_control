# This class represents Chamberlain Devices
#   only garage door family types are currently tracked
require "./device_state"

class Device < Jennifer::Model::Base
  with_timestamps
  mapping(
    id: {type: Int64, primary: true},
    serial_number: String?,
    family: String?,
    platform: String?,
    kind: String?,
    state: JSON::Any?,
    remote_credential_id: Int64?,
    remote_created_at: Time?,
    nest_share_id: String?,
    created_at: Time?,
    updated_at: Time?
  )

  belongs_to :remote_credential, RemoteCredential
  has_many :access_windows, AccessWindow

  def transition_door_state
    if (transition_state = next_state)
      # state_hash = state.not_nil!.as_h
      device_state = DeviceState.from_json(state.not_nil!.to_json)
      if device_state
        device_state.door_state = transition_state.to_s
        self.state = JSON.parse(device_state.to_json)
      end

      # if state_hash
      #   state_hash["door_state"] = JSON.parse(transition_state.to_s)
      #   self.state = JSON.parse(state_hash.to_json)
      # end
    end
  end

  def next_state : String?
    if try &.state.try &.as_h.has_key?("door_state")
      current_state = state.try(&.as_h["door_state"])
      return(self.class.next_state(current_state.to_s))
    end
    return(nil)
  end

  def next_state_command : String?
    if try &.state.try &.as_h.has_key?("door_state")
      current_state = state.try(&.as_h["door_state"])
      return(self.class.next_state_command(current_state.to_s))
    end
    return(nil)
  end

  def self.next_state_command(current : String?) : String?
    case current.to_s
    when "closed"
      return("open")
    when "open"
      return("close")
    else
      return(nil)
    end
  end

  def self.next_state(current : String?) : String?
    case current.to_s
    when "closed"
      return("opening")
    when "opening"
      return("open")
    when "open"
      return("closing")
    when "closing"
      return("closed")
    else
      return(nil)
    end
  end
end
