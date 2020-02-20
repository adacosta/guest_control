module Chamberlain
  class GarageDoors

    def initialize(remote_credential : RemoteCredential)
      @remote_credential = remote_credential
    end

    # curl -v -X GET -H 'Content-Type: application/json' -H 'SecurityToken: ...' -H 'MyQApplicationId: JVM/G9Nwih5BwKgNCjLxiFUQxQijAebyyg8QUHr7JOrP+tuPb8iHfRHKwTmDzHOu' 'https://api.myqdevice.com/api/v5/My?expand=account'
    def fetch : Array(Device)
      devices = Array(Device).new

      if @remote_credential
        # TODO: update all get calls to use an HTTP::Client instance to implement connect_timeout and read_timeout with being/rescue IO::Timeout
        #   see https://crystal-lang.org/api/0.20.1/HTTP/Client.html for examples
        headers = HTTP::Headers{"Content-Type" => "application/json", "MyQApplicationId" => ::Chamberlain::APP_ID, "SecurityToken" => @remote_credential.chamberlain_security_token.not_nil!}
        if account_id = @remote_credential.chamberlain_account_id
          uri = ::Chamberlain.devices_uri(account_id)
          HTTP::Client.get(uri, headers: headers) do |response|
            if body = response.body_io.gets
              Amber.logger.info("devices body = #{body}")
              json_body = JSON.parse(body)
              # can't check keys on json_body without converting to hash :(
              body_hash = json_body.as_h

              if body_hash.has_key?("items") && (items = body_hash["items"].as_a)
                Amber.logger.info("items = #{items}")

                items.each do |item|
                  item = item.as_h

                  Amber.logger.info("item = #{item}")
                  if device_family = item["device_family"]
                    if device_family == "garagedoor"
                      device = Device.where { _serial_number == item["serial_number"].to_s}.first
                      if device
                        device.update(state: item["state"])
                        Amber.logger.info("Device id #{device.id} updated\n\n#{device.inspect}\n\n")
                      else
                        device = Device.create(
                          serial_number: item["serial_number"].to_s,
                          family: item["device_family"].to_s,
                          platform: item["device_platform"].to_s,
                          kind: item["device_type"].to_s,
                          remote_created_at: Time.parse(item["created_date"].to_s, "%Y-%m-%dT%H:%M:%S", Time::Location::UTC),
                          state: item["state"],
                          remote_credential_id: @remote_credential.id,
                        )
                        Amber.logger.info("Device created for remote_credential.id #{@remote_credential.id}\n\n#{device.inspect}\n\n")
                      end
                      Amber.logger.info("Pushing device for create/update: #{device.id}")
                      devices << device
                    end
                  end
                end
              end

              @remote_credential.save!

              Amber.logger.info("Request: devices#get; #{body}; status_code: #{response.status_code}")
              # log_request(remote_credential: @remote_credential, body: body, code: response.status_code)
            end
          end
        end
      end
      devices
    end

    private def log_request(remote_credential : RemoteCredential, body : String?, code : Int32?) : Request
      Request.create(
        kind: "devices#get",
        response: body,
        response_code: code,
        remote_credential_id: remote_credential.id,
        created_at: Time.utc
      )
    end
  end
end