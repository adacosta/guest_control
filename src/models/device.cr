# This class represents Chamberlain Devices
#   only garage door family types are currently tracked
require "./device_state"

class Device < Jennifer::Model::Base
  OPEN = "open"
  OPENED = "opened"
  OPENING = "opening"
  CLOSE = "close"
  CLOSED = "closed"
  CLOSING = "closing"

  with_timestamps
  mapping(
    id: {type: Int64, primary: true},
    serial_number: String?,
    family: String?,
    platform: String?,
    kind: String?,
    transition_state: String?,
    transition_state_at: Time?,
    state: JSON::Any?,
    remote_credential_id: Int64?,
    remote_created_at: Time?,
    nest_share_id: String?,
    created_at: Time?,
    updated_at: Time?
  )

  belongs_to :remote_credential, RemoteCredential
  has_many :access_windows, AccessWindow

  def advance_transition_state
    if (_transition_state = next_state)
      # state_hash = state.not_nil!.as_h
      # device_state = DeviceState.from_json(state.not_nil!.to_json)
      # if device_state
        # device_state.door_state = transition_state.to_s
        Amber.logger.info("transitioning state to #{_transition_state.to_s}")
        self.transition_state = _transition_state.to_s
        self.transition_state_at = Time.utc

        # self.state = JSON.parse(device_state.to_json)
      # end
      _transition_state
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
      return(OPEN)
    when "open"
      return(CLOSE)
    else
      return(nil)
    end
  end

  def self.next_state(current : String?) : String?
    case current.to_s
    when "closed"
      return(OPENING)
    when "opening"
      return(CLOSED)
    when "open"
      return(CLOSING)
    when "closing"
      return(OPENED)
    else
      return(nil)
    end
  end
end
