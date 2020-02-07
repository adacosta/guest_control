# This class mirrors the state attributes returned by the Chamberlain devices API

# {
#   "gdo_lock_connected": false,
#   "attached_work_light_error_present": false,
#   "door_state": "closed",
#   "open": "http:\/\/api.myqdevice.com\/api\/v5\/accounts\/6d3c77dc-22a4-4dff-802b-78453035b775\/devices\/CG08600F5352\/open",
#   "close": "http:\/\/api.myqdevice.com\/api\/v5\/accounts\/6d3c77dc-22a4-4dff-802b-78453035b775\/devices\/CG08600F5352\/close",
#   "last_update": "2020-01-26T18:51:48.3816064Z",
#   "passthrough_interval": "00:00:00",
#   "door_ajar_interval": "00:00:00",
#   "invalid_credential_window": "00:00:00",
#   "invalid_shutout_period": "00:00:00",
#   "is_unattended_open_allowed": true,
#   "is_unattended_close_allowed": true,
#   "aux_relay_delay": "00:00:00",
#   "use_aux_relay": false,
#   "aux_relay_behavior": "None",
#   "rex_fires_door": false,
#   "command_channel_report_status": false,
#   "control_from_browser": false,
#   "report_forced": false,
#   "report_ajar": false,
#   "max_invalid_attempts": 0,
#   "online": true,
#   "last_status": "2020-01-26T23:22:11.1467933Z"
# }

struct DeviceState
  JSON.mapping(
    gdo_lock_connected: Bool,
    attached_work_light_error_present: Bool,
    door_state: String,
    open: String,
    close: String,
    last_update: Time,
    passthrough_interval: String,
    invalid_credential_window: String,
    invalid_shutout_period: String,
    is_unattended_open_allowed: Bool,
    is_unattended_close_allowed: Bool,
    aux_relay_delay: String,
    aux_relay_behavior: String,
    rex_fires_door: Bool,
    command_channel_report_status: Bool,
    control_from_browser: Bool,
    report_forced: Bool,
    report_ajar: Bool,
    max_invalid_attempts: Int64,
    online: Bool,
    last_status: Time
  )
end