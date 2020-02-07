module Chamberlain
  class GarageDoor

    def initialize(device : Device)
      @device = device
    end

    def invoke_action(name : String)
      if remote_credential = @device.try &.remote_credential
        account_id = remote_credential.chamberlain_account_id
        if account_id && (uri = ::Chamberlain.device_invoke_action_uri(account_id, @device.serial_number))
          if security_token = @device.remote_credential.try &.chamberlain_security_token.not_nil!
            Amber.logger.info("uri = #{uri}")
            headers = HTTP::Headers{"Content-Type" => "application/json", "MyQApplicationId" => ::Chamberlain::APP_ID, "SecurityToken" => security_token}
            json_body = {action_type: name}.to_json
            Amber.logger.info("headers #{headers}")
            Amber.logger.info("json_body #{json_body}")
            HTTP::Client.put(url: uri, headers: headers, body: json_body.to_s) do |response|
              # if body = response.body_io.gets
              #   log_request(remote_credential: remote_credential, body: body, code: response.status_code, action: name)
              #   Amber.logger.info("Chamberlain::Garagedoor#action body = #{body}")
              # end
            end
          end
        end
      else
        Amber.logger.info("Chamberlain::Garagedoor#action endpoint '#{name}' not found for device #{@device.id}")
      end
    end

    private def log_request(remote_credential : RemoteCredential, body : String?, code : Int32?, action : String) : Request
      Request.create(
        kind: "garage_door##{action}",
        response: body,
        response_code: code,
        remote_credential_id: remote_credential.id,
        created_at: Time.utc
      )
    end
  end
end