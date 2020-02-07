class Device {
  static updateInterval() {
    return(5000);
  }

  static updateTimeToRelative(id) {
    var el = document.getElementById(id);
    if (el) {
      let value = el.innerText;
      if (value) {
        value = moment(value).fromNow();
      };
      el.innerText = value;
      el.style.display = 'inline';
    }
    return(el);
  }

  static updateStatus(id, status) {
    var el = document.getElementById(id);
    if (el) {
      el.innerText = status;
    }
    return(el);
  }

  static changeDeviceState(event) {
    event.preventDefault();
    if (window.devicesChannel) {
      var target = $(event.target)[0]
      var deviceId = target.dataset.deviceId;
      var deviceNextState = target.dataset.deviceNextState;
      // TODO: create spinner over button
      target.classList.add("three-quarters-loader");
      // TODO: fire action
      window.devicesChannel.push('invoke_device_action', {device_id: deviceId, action: deviceNextState});
      // TODO: locally increment state (really button label)
      // TODO: remove spinner on next response
    } else {
      console.log("error: window.devicesChannel not present");
    }
  }

  // owner control
  static createUpdateLoopByRemoteCredentialId(remote_credential_id) {
    let socket = new Amber.Socket('/remote_credential_devices');
    socket.connect().then((m) => {

      window.devicesChannel = socket.channel('device_updates:remote_credential_id:' + remote_credential_id);
      window.devicesChannel.join();

      var update_interval = window.setInterval(() => {
        try {
          window.devicesChannel.push('request_device_updates', {});
        }
        catch(error) {
          console.error(error);
          // assume the websocket connection is broken
          Device.createUpdateLoopByRemoteCredentialId(remote_credential_id);
        }
        }, Device.updateInterval()
      )

      window.devicesChannel.on('device_updates', (payload) => {
        console.log("device_updates received", payload)
        payload.message.forEach((device) => {
          if (device) {
            var id = device.id;

            Device.updateStatus("device-" + id + "-remote_created_at", device.remote_created_at);
            Device.updateTimeToRelative("device-" + id + "-remote_created_at");
            Device.updateStatus("device-" + id + "-last_update", device.last_update);
            Device.updateTimeToRelative("device-" + id + "-last_update");
            Device.updateStatus("device-" + id + "-last_status", device.last_status);
            Device.updateTimeToRelative("device-" + id + "-last_status");

            Device.updateStatus("device-" + id + "-online", device.online);
            Device.updateStatus("device-" + id + "-door_state", device.door_state);

            var next_state_command_button = document.getElementById("device-" + id + "-next_state_command_button");
            var capitalized_next_state = device.next_state_command;

            // update button command label
            next_state_command_button.innerText = capitalized_next_state;
            next_state_command_button.dataset.deviceNextState = device.next_state_command;

            // remove loading spinner
            next_state_command_button.classList.remove("three-quarters-loader");

          }
        })
      })
    });
  }

  // guest control
  static createUpdateLoopByDeviceId(device_id) {
    let socket = new Amber.Socket('/devices');
    socket.connect().then((m) => {

      window.devicesChannel = socket.channel('device_updates:device_id:' + device_id);
      window.devicesChannel.join();

      var update_interval = window.setInterval(() => {
        try {
          window.devicesChannel.push('request_device_updates', {});
        }
        catch(error) {
          console.error(error);
          // assume the websocket connection is broken
          Device.createUpdateLoopByDeviceId(device_id);
        }
        }, Device.updateInterval()
      )

      window.devicesChannel.on('device_updates', (payload) => {
        console.log("device_updates received", payload)
        var device = payload.message

        if (device) {
          var id = device.id;

          Device.updateStatus("device-" + id + "-last_status", device.last_status);
          Device.updateTimeToRelative("device-" + id + "-last_status");

          Device.updateStatus("device-" + id + "-online", device.online);
          Device.updateStatus("device-" + id + "-door_state", device.door_state);

          var next_state_command_button = document.getElementById("device-" + id + "-next_state_command_button");
          var capitalized_next_state = device.next_state_command;

          // update button command label
          next_state_command_button.innerText = capitalized_next_state;
          next_state_command_button.dataset.deviceNextState = device.next_state_command;

          // remove loading spinner
          next_state_command_button.classList.remove("three-quarters-loader");
        }

      })
    });
  }
}