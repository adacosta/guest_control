# TODO: Verify access rights

class AccessWindowController < ApplicationController
  getter access_window = AccessWindow.new
  getter guest = Guest.new

  before_action do
    only [:index, :new, :create] { set_guest }
    only [:show, :edit, :update, :destroy] { set_access_window }
  end

  def index
    access_windows = AccessWindow.where { _guest_id == @guest.id }
    render "index.ecr"
  end

  def show
    render "show.ecr"
  end

  def new
    @access_window = AccessWindow.new({"guest_id" => @guest.id.not_nil!})
    render "new.ecr"
  end

  def edit
    render "edit.ecr"
  end

  def create
    Amber.logger.info("access window params = #{access_window_params.inspect}")
    # html select submits an array of ids as strings
    # if params["guest_id"] && params["guest_id"].any?
    #   params["guest_id"] = params["guest_id"][0].to_i64
    # end
    # if params["device_id"] && params["device_id"].any?
    #   params["device_id"] = params["device_id"][0].to_i64
    # end
    # Amber.logger.info("access window params 2 = #{access_window_params.inspect}")

    params_hash = access_window_params.validate!
    guest_id = params["guest_id"].not_nil!.to_i64
    device_id = params_hash["device_id"].not_nil!.to_i64
    device = Device.find(device_id)
    start_at = format_time(params_hash["start_at"].not_nil!, device.not_nil!.remote_credential.not_nil!)
    end_at = format_time(params_hash["end_at"].not_nil!, device.not_nil!.remote_credential.not_nil!)
    new_params = {
      "guest_id" => guest_id,
      "device_id" => device_id,
      "start_at" => start_at,
      "end_at" => end_at,
      "guest_id" => @guest.id
    }
    access_window = AccessWindow.new(new_params)
    if access_window.save
      redirect_to "/guests/#{@guest.id}/access_windows", flash: {"success" => "Access window has been created."}
    else
      flash[:danger] = "Could not create Access Window!"
      render "new.ecr"
    end
  end

  def update
    access_window.set_attributes access_window_params.validate!
    access_window.set_attributes(guest_id: @guest.id)
    if access_window.save
      redirect_to action: :index, flash: {"success" => "Access Window has been updated."}
    else
      flash[:danger] = "Could not update Access Window!"
      render "edit.ecr"
    end
  end

  def destroy
    access_window.destroy
    redirect_to action: :index, flash: {"success" => "Access Window has been deleted."}
  end

  private def access_window_params
    params.validation do
      required :device_id
      required :start_at
      required :end_at
    end
  end

  private def set_access_window
    @access_window = AccessWindow.find!(params[:id])
  end

  private def set_guest
    @guest = Guest.find!(params["guest_id"].not_nil!.to_i64)
  end

  private def format_time(time_string : String, remote_credential : RemoteCredential) : Time
    time_zone = remote_credential.time_zone.not_nil!
    location = Time::Location.load(time_zone)
    old_time = Time::Format.new("%FT%R").parse(time_string, Time::Location::UTC)
    # Time.parse(time_string, "%FT%R", Time::Location::UTC)
    Time.local(old_time.year, old_time.month, old_time.day, old_time.hour, old_time.minute, old_time.second, location: location)
  end
end
