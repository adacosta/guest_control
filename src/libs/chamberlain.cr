require "http/client"

module Chamberlain
  APP_ID = "JVM/G9Nwih5BwKgNCjLxiFUQxQijAebyyg8QUHr7JOrP+tuPb8iHfRHKwTmDzHOu"
  BASE_URI = "https://api.myqdevice.com/"
  LOGIN_ENDPOINT = "api/v5/Login"
  ACCOUNT_ENDPOINT = "api/v5/My?expand=account"
  DEVICE_LIST_ENDPOINT = "api/v5/Accounts/{accountId}/Devices"
  DEVICE_SET_ENDPOINT = "api/v5/Accounts/{accountId}/Devices/{serialNumber}/actions"

  DEVICE_TYPES = {
    hub: "hub",
    garageDoorOpener: "virtualgaragedooropener",
  }

  ERROR_MESSAGES = {
    11 => "Something unexpected happened. Please wait a bit and try again.",
    12 => "MyQ service is currently down. Please wait a bit and try again.",
    13 => "Not logged in.",
    14 => "Email and/or password are incorrect.",
    15 => "Invalid parameter(s) provided.",
    16 => "User will be locked out due to too many tries. 1 try left.",
    17 => "User is locked out due to too many tries. Please reset password and try again.",
    18 => "The requested device could not be found.",
    19 => "Unable to determine the state of the requested device.",
    20 => "Could not find that URL. Please file a bug report."
  }

  DOOR_COMMANDS = {
    close: "close",
    open: "open",
  }

  DOOR_STATES = {
    1 => "open",
    2 => "closed",
    3 => "stopped in the middle",
    4 => "going up",
    5 => "going down",
    9 => "not closed",
  }

  LIGHT_COMMANDS = {
    on: "on",
    off: "off",
  }

  LIGHT_STATES = {
    0 => "off",
    1 => "on",
  }

  MYQ_PROPERTIES = {
    doorState: "door_state",
    lastUpdate: "last_update",
    lightState: "light_state",
    online: "online",
  }

  def self.login_uri
    BASE_URI + LOGIN_ENDPOINT
  end

  def self.account_uri
    BASE_URI + ACCOUNT_ENDPOINT
  end

  def self.devices_uri(account_id)
    BASE_URI + "api/v5/Accounts/" + account_id + "/Devices"
  end

  # eg. https://api.myqdevice.com/api/v5/Accounts/6d3c77dc-22a4-4dff-802b-78453035b775/devices/CG08600F5352/actions
  def self.device_invoke_action_uri(account_id, device_id)
    BASE_URI + "api/v5/Accounts/" + account_id.to_s + "/devices/" + device_id.to_s + "/actions"
  end
end

require "./chamberlain/auth"
require "./chamberlain/account"
require "./chamberlain/garage_door"
require "./chamberlain/garage_doors"