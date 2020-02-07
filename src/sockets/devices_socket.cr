struct DevicesSocket < Amber::WebSockets::ClientSocket
  # (updates for all devices associated to a given remote_credential)
  channel "device_updates:device_id:*", DevicesChannel

  def on_connect
    # do some authentication here
    # return true or false, if false the socket will be closed
    # Amber.logger.info("Checking logged in for #{session.inspect}")
    # no need to check for signed in status because the url proves identity
    # signed_in?
    Amber.logger.info("DevicesSocket on_connect")
    return(true)
  end
end
