class Request < Jennifer::Model::Base
  with_timestamps
  mapping(
    id: {type: Int64, primary: true},
    kind: String?,
    response: String?,
    response_code: Int32?,
    remote_credential_id: Int64?,
    created_at: Time?
  )

  belongs_to :remote_credential, RemoteCredential
end
