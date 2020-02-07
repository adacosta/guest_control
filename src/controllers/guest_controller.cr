class GuestController < ApplicationController
  getter guest = Guest.new

  before_action do
    all { redirect_signed_out_user }
  end

  before_action do
    only [:show, :edit, :update, :destroy] { set_guest }
  end

  def index
    guests = Guest.all
    render "index.ecr"
  end

  def show
    render "show.ecr"
  end

  def new
    render "new.ecr"
  end

  def edit
    render "edit.ecr"
  end

  def create
    @validation_errors = [] of Amber::Validators::Error
    if user = current_user
      params["user_id"] = user.id.to_s
    end
    guest = Guest.new guest_params.validate!
    if guest && guest.save
      redirect_to action: :index, flash: {"success" => "Guest has been created."}
    else
      flash[:danger] = "Could not create Guest!"
      render "new.ecr"
    end
  rescue e : Amber::Exceptions::Validator::ValidationFailed
    guest ||= Guest.new
    @validation_errors = e.errors
    render "new.ecr"
  end

  def update
    guest.set_attributes guest_params.validate!
    if guest.save
      redirect_to action: :index, flash: {"success" => "Guest has been updated."}
    else
      flash[:danger] = "Could not update Guest!"
      render "edit.ecr"
    end
  end

  def destroy
    guest.destroy
    redirect_to action: :index, flash: {"success" => "Guest has been deleted."}
  end

  private def guest_params
    params.validation do
      required(:name)
      optional(:note)
    end
  end

  private def set_guest
    @guest = Guest.find! params[:id]
  end
end
