module Chamberlain
  class Account
    def initialize(remote_credential : RemoteCredential)
      @remote_credential = remote_credential
    end

    # curl -v -X GET -H 'Content-Type: application/json' -H 'SecurityToken: ...' \
    #   -H 'MyQApplicationId: JVM/G9Nwih5BwKgNCjLxiFUQxQijAebyyg8QUHr7JOrP+tuPb8iHfRHKwTmDzHOu' \
    #   'https://api.myqdevice.com/api/v5/My?expand=account'
    def fetch
      if @remote_credential
        clear
        headers = HTTP::Headers{"Content-Type" => "application/json", "MyQApplicationId" => ::Chamberlain::APP_ID, "SecurityToken" => @remote_credential.chamberlain_security_token.not_nil!}
        HTTP::Client.get(::Chamberlain.account_uri, headers: headers) do |response|
          if body = response.body_io.gets
            Amber.logger.info("account body = #{body}")

            json_body = JSON.parse(body)

            if json_body["Account"]["Id"]
              @remote_credential.chamberlain_account_id = json_body["Account"]["Id"].as_s
            end

            if json_body["Account"]["TimeZone"]
              @remote_credential.time_zone = json_body["Account"]["TimeZone"].as_s
            end

            @remote_credential.save!

            Amber.logger.info("Request: account#get; #{body}; status_code: #{response.status_code}")
            # log_request(remote_credential: @remote_credential, response_body: body, response_code: response.status_code)

            @remote_credential
          end
        end
      end
    end

    private def log_request(remote_credential : RemoteCredential, response_body : String?, response_code : Int32?) : Request
      Request.create(
        kind: "account#get",
        response: response_body,
        response_code: response_code,
        remote_credential_id: remote_credential.id,
        created_at: Time.utc
      )
    end

    private def clear
      @remote_credential.chamberlain_account_id = nil
      @remote_credential.time_zone = nil
    end
  end
end