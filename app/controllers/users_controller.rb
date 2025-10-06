# frozen_string_literal: true

class UsersController < ApplicationController

  include Pagy::Backend
  include GenericCrudLoader

  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    load_crud_records(model: User, items: 10)
    respond_to do |format|
      format.turbo_stream
      format.html
      format.json { render json: records }
    end
  end

  def new
    @user = User.new
    render turbo_stream: turbo_stream.update("modal", partial: "users/form", locals: { user: @user }), layout: false
  end

  def create
    result = GenericCrudInteractor.call(
      model: User,
      action: :create,
      params: user_params
    )
    if result.success?
      load_crud_records(model: User, items: 10)
      render turbo_stream: turbo_stream.replace(
        "users_list",
        partial: "users/index",
        locals: {
          columns: [:email],
          records: @records,
          pagy: @pagy,
          ransack: @ransack,
          results_frame_id: "users_list"
        }
      )
    else
      @user = User.new(user_params)
      @user.errors.add(:base, result.error)
      render turbo_stream: turbo_stream.replace(
        "modal",
        partial: "users/form",
        locals: { user: @user }
      ), status: :unprocessable_entity
    end
  end

  def edit
    render layout: false
  end

  def update
    result = GenericCrudInteractor.call(
      model: User,
      action: :update,
      id: @user.id,
      params: user_params
    )
    if result.success?
      redirect_to users_path, notice: "User updated"
    else
      @user.errors.add(:base, result.error)
      render :edit, status: :unprocessable_entity, layout: false
    end
  end

  def destroy
    GenericCrudInteractor.call(model: User, action: :delete, id: @user.id)
    redirect_to users_path, notice: "User deleted"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
