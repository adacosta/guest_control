struct RemoteCredentialDevicesSocket < Amber::WebSockets::ClientSocket
  # (updates for all devices associated to a given remote_credential)
  channel "device_updates:remote_credential_id:*", RemoteCredentialDevicesChannel

  def on_connect
    # do some authentication here
    # return true or false, if false the socket will be closed
    # Amber.logger.info("Checking logged in for #{session.inspect}")
    signed_in?
  end

  private def current_user
    if user_id = self.session[:user_id]
      user = User.find(user_id)
      Amber.logger.info("user = #{user}")
      return user
    end
    return nil
  end

  private def signed_in?
    !!current_user
  end
end
