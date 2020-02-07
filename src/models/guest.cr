class Guest < Jennifer::Model::Base
  with_timestamps
  mapping(
    id: {type: Int64, primary: true},
    name: String?,
    note: String?,
    user_id: Int64?,
    created_at: Time?,
    updated_at: Time?
  )

  belongs_to :user, User
  has_many :access_windows, AccessWindow
end