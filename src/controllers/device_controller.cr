class DeviceController < ApplicationController
  getter device = Device.new

  before_action do
    only [:show, :edit, :update, :destroy] { set_device }
  end

  def index
    devices = Device.all
    render "index.ecr"
  end

  def show
    respond_with do
      html render "show.ecr"
      js do
        render "_card.ecr", layout: false
      end
    end
  end

  def edit
    respond_with do
      html render "edit.ecr"
      js do
        render "edit.ecr", layout: false
      end
    end
  end

  def update
    device.set_attributes device_params.validate!
    if device && device.save
      respond_with do
        html do
          redirect_back(status: 204, flash: {"success" => "Garage door has been updated."})
          ""
        end
        # js render("_card.ecr", layout: false)
        js do
           redirect_to("/remote_credentials")
           ""
        end
      end
    else
      flash[:danger] = "Could not update Garage door!"
      respond_with do
        html render("edit.ecr")
        js render("_card.ecr", layout: false)
      end
    end
  # rescue e : Amber::Exceptions::Validator::ValidationFailed
  #   @validation_errors = e.errors
  #   respond_with do
  #     html render("edit.ecr")
  #     js render("_card.ecr", layout: false)
  #   end
  end

  def destroy
    device.destroy
    redirect_back status: 302, flash: {"success" => "Garage door has been deleted."}
  end

  private def set_device
    @device = Device.find! params[:id]
  end

  private def device_params
    params.validation do
      optional(:nest_share_id)
    end
  end
end
