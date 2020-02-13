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

      window.updateInterval = window.setInterval(() => {
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
            var command = device.next_state_command;
            var capitalized_next_state = command.charAt(0).toUpperCase() + command.slice(1)

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

  static removeUpdateLoop() {
    window.clearInterval(window.updateInterval);
    return(window.updateInterval = null);
  }

  static updateLoopPresent() {
    return(!!window.updateInterval);
  }

  static createUpdateLoopByDeviceIdWithTabVisibilityDetection(device_id) {
    Device.createUpdateLoopByDeviceId(device_id);

    // Set the name of the hidden property and the change event for visibility
    var hidden, visibilityChange;
    if (typeof document.hidden !== "undefined") { // Opera 12.10 and Firefox 18 and later support
      hidden = "hidden";
      visibilityChange = "visibilitychange";
    } else if (typeof document.msHidden !== "undefined") {
      hidden = "msHidden";
      visibilityChange = "msvisibilitychange";
    } else if (typeof document.webkitHidden !== "undefined") {
      hidden = "webkitHidden";
      visibilityChange = "webkitvisibilitychange";
    }

    // If the page is hidden, stop websocket updates
    // if the page is shown, start webscoket updates
    function handleVisibilityChange() {
      if (document[hidden]) {
        console.log("removing update loop");
        Device.removeUpdateLoop();
        Device.setNextStateCommandButtonToLoading(device_id);
      } else {
        if (!Device.updateLoopPresent()) {
          console.log("creating update loop");
          Device.createUpdateLoopByDeviceId(device_id);
        }
      }
    }

    // Warn if the browser doesn't support addEventListener or the Page Visibility API
    if (typeof document.addEventListener === "undefined" || hidden === undefined) {
      // console.log("Toggling update state requires a browser, such as Google Chrome or Firefox, that supports the Page Visibility API.");
    } else {
      // Handle page visibility change
      document.addEventListener(visibilityChange, handleVisibilityChange, false);
    }
  }

  static setNextStateCommandButtonToLoading(id) {
    var button = Device.nextStateCommandButton(id);
    if (button) {
      button.classList.add("three-quarters-loader");
      return(button);
    }
    return(null);
  }

  static nextStateCommandButton(id) {
    return(document.getElementById("device-" + id + "-next_state_command_button"));
  }

  // guest control
  static createUpdateLoopByDeviceId(device_id) {
    let socket = new Amber.Socket('/devices');

    socket.connect().then((m) => {
      console.log("socket connect");
      window.devicesChannel = socket.channel('device_updates:device_id:' + device_id);
      window.devicesChannel.join();
      console.log("devicesChannel join");
      window.devicesChannelPushCountWithoutResponse = 0;

      Device.removeUpdateLoop()

      window.updateInterval = window.setInterval(() => {
        try {
          // only send if the socket is open
          console.log("socket", socket);
          if (socket.ws && (socket.ws.readyState === WebSocket.OPEN)) {
            if(window.devicesChannelPushCountWithoutResponse > 3) {
              // server might have restarted connection and won't respond to messages without first having a join
              // this has to do with the server using redis pub/sub
              console.log("rejoining channel since push count exceeds response threshold")
              window.devicesChannel.join();
            }

            window.devicesChannel.push('request_device_updates', {});
            window.devicesChannelPushCountWithoutResponse += 1;
          } else {
            throw "Socket not in an OPEN state"
          }
        }
        catch(error) {
          console.log("Error: ", error);
          window.reconnectInterval = window.setTimeout(() => {
            console.log("Re-initing createUpdateLoopByDeviceId from error push")
            Device.createUpdateLoopByDeviceId(device_id);
           }, 4000
          )
          // assume the websocket connection is broken
          // Device.createUpdateLoopByDeviceId(device_id);
        }
        }, Device.updateInterval()
      )

      window.devicesChannel.on('device_updates', (payload) => {
        window.devicesChannelPushCountWithoutResponse = 0;
        console.log("device_updates received", payload);
        var device = payload.message;

        if (device) {
          var id = device.id;

          Device.updateStatus("device-" + id + "-last_status", device.last_status);
          Device.updateTimeToRelative("device-" + id + "-last_status");

          Device.updateStatus("device-" + id + "-online", device.online);
          Device.updateStatus("device-" + id + "-door_state", device.door_state);

          var next_state_command_button = Device.nextStateCommandButton(id);
          var current_state_label = document.getElementById("device-" + id + "-current_state");

          console.log("device = ", device);
          if (device.door_state == 'opening' || device.door_state == 'closing') {
            // in an interim state: opening or closing
            var state = device.door_state;
            console.log("2 setting state to ", state);
            current_state_label.innerText = state;

            next_state_command_button.style.display = 'none';
            current_state_label.style.display = 'block';
          } else {
            // in a final state: open or close
            var command = device.next_state_command;
            console.log("1 setting command to ", command);
            // update button command label
            next_state_command_button.innerText = command;
            next_state_command_button.dataset.deviceNextState = device.next_state_command;
            current_state_label.style.display = 'none';
            next_state_command_button.style.display = 'block';
          }

          // remove loading spinner
          next_state_command_button.classList.remove("three-quarters-loader");
        }

      })
    });

    socket.onclose = () => {
      console.log("Socket onclose");
      if (window.reconnectInterval) {
        window.clearInterval(window.reconnectInterval);
      };

      window.reconnectInterval = window.setTimeout(() => {
        console.log("Re-initing createUpdateLoopByDeviceId");
        Device.createUpdateLoopByDeviceId(device_id);
       }, 20000
      )
    }

    socket.onerror = (err) => {
      console.log('Socket encountered error: ', err.message, 'Closing socket');
      socket.close();
    };
  }
}