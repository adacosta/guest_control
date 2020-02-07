class UserController < ApplicationController
  before_action do
    all { redirect_signed_out_user }
  end

  def show
    render("show.ecr") if (user = current_user)
  end

  def edit
    render("edit.ecr") if (user = current_user)
  end

  def update
    user = current_user
    if update(user)
      flash[:success] = "Updated Profile successfully."
      redirect_to "/profile"
    elsif user
      flash[:danger] = "Could not update Profile!"
      render("edit.ecr")
    else
      flash[:info] = "Must be logged in"
      redirect_to "/signin"
    end
  end

  private def update(user)
    return false unless user && user_params.valid?
    user.set_attributes(user_params.to_h)
    user.valid? && user.save
  end

  private def user_params
    params.validation do
      required(:email)
      optional(:password)
    end
  end
end
