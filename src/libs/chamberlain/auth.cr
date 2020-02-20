module Chamberlain
  class Auth
    def initialize(remote_credential : RemoteCredential)
      @remote_credential = remote_credential
    end

    def login : RemoteCredential
      clear
      headers = HTTP::Headers{"Content-Type" => "application/json", "MyQApplicationId" => ::Chamberlain::APP_ID}
      json_body = {username: @remote_credential.username, password: @remote_credential.password}.to_json
      HTTP::Client.post(::Chamberlain.login_uri, headers: headers, body: json_body.to_s) do |response|
        if body = response.body_io.gets
          Amber.logger.info("auth body = #{body}")

          json_body = JSON.parse(body)

          if json_body["SecurityToken"]
            @remote_credential.chamberlain_security_token = json_body["SecurityToken"].as_s
          end

          @remote_credential.last_auth_request_at = Time.utc
          @remote_credential.save!

          Amber.logger.info("Request: login#post; #{body}; status_code: #{response.status_code}")
          # log_request(remote_credential: @remote_credential, body: body, code: response.status_code)

          @remote_credential
        end
      end
      @remote_credential
    end

    private def log_request(remote_credential : RemoteCredential, body : String?, code : Int32?) : Request
      Amber.logger.info("\nbody: #{body}\ncode: #{code}\n")
      Request.create(
        kind: "login#post",
        response: body,
        response_code: code,
        remote_credential_id: remote_credential.id,
        created_at: Time.utc
      )
    end

    private def clear
      @remote_credential.last_auth_request_at = nil
      @remote_credential.chamberlain_security_token = nil
    end
  end
end