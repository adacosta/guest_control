class GuestDeviceController < ApplicationController
  getter access_window = AccessWindow.new
  getter device = Device.new

  before_action do
    only [:show] { set_access_window_and_device }
  end

  def show
    if @access_window.expired?
      response.status_code = 410
      render "show_expired.ecr", layout: false
    elsif @access_window.valid?
      response.status_code = 200
      render "show.ecr", layout: false
    else
      response.status_code = 404
      render "show_not_found.ecr", layout: false
    end
  end

  private def set_access_window_and_device
    _access_window = AccessWindow.where { _slug == params[:slug] }.limit(1).first
    if _access_window
      @access_window = _access_window
      if device = @access_window.device
        @device = device
      end
    end
  end
end