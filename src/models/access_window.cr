require "uuid"

class AccessWindow < Jennifer::Model::Base
  with_timestamps
  mapping(
    id: {type: Int64, primary: true},
    guest_id: Int64?,
    device_id: Int64?,
    start_at: Time?,
    end_at: Time?,
    slug: String?,
    created_at: Time?,
    updated_at: Time?
  )

  belongs_to :guest, Guest
  belongs_to :device, Device

  before_create :generate_slug

  def expired? : Bool
    !(start_at && end_at && Time.utc > start_at.not_nil! && Time.utc < end_at.not_nil!)
  end

  def valid? : Bool
    !!(start_at && end_at && slug && guest_id && device_id)
  end

  private def generate_slug
    self.slug = UUID.random.to_s[-12..-1]
  end
end
