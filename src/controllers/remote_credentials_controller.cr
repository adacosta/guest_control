class RemoteCredentialsController < ApplicationController
  getter remote_credential = RemoteCredential.new

  before_action do
    all { redirect_signed_out_user }
  end

  before_action do
    only [:show, :edit, :update, :destroy] { set_remote_credential }
  end

  def index
    remote_credentials = RemoteCredential.where { _user_id == current_user.try &.id }
    remote_credentials = remote_credentials.includes("devices")
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
    attributes = {"user_id" => current_user.try(&.id)}.merge(remote_credential_params.validate!)
    remote_credential = RemoteCredential.new({"user_id" => current_user.try(&.id)}.merge(remote_credential_params.validate!))
    remote_credential.password = params["password"].to_s
    if remote_credential.save
      ChamberlainAuthWorker.async.perform(remote_credential.id.not_nil!)
      redirect_to action: :index, flash: {"success" => "Remote credential has been created."}
    else
      flash[:danger] = "Could not create Remote Credential!"
      render "new.ecr"
    end
  end

  def update
    unless remote_credential.user.try &.id.not_nil! == current_user.not_nil!.id.not_nil!
      render_forbidden && return
    end
    remote_credential.set_attributes({"user_id" => current_user.try(&.id)}.merge(remote_credential_params.validate!))
    remote_credential.password = params["password"].to_s
    if remote_credential.save
      ChamberlainAuthWorker.async.perform(remote_credential.id.not_nil!)
      redirect_to action: :index, flash: {"success" => "Remote credential has been updated."}
    else
      flash[:danger] = "Could not update Remote Credential!"
      render "edit.ecr"
    end
  end

  def destroy
    remote_credential.destroy
    redirect_to action: :index, flash: {"success" => "Remote credential has been deleted."}
  end

  private def remote_credential_params
    params.validation do
      required :username
    end
  end

  private def set_remote_credential
    @remote_credential = RemoteCredential.find! params[:id]
  end

  private def render_forbidden
    respond_with do
      html do
        flash[:danger] = "You can't do that"
        redirect_to :index
      end
      json do
        response.status = HTTP::Status::FORBIDDEN
        {:error => "You can't do that"}.to_json
      end
    end
  end
end
