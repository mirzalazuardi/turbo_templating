# frozen_string_literal: true

class UsersController < ApplicationController

  include Pagy::Backend

  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    ransack_params = params[:q] || {}
    ransack_params = fix_ransack_params(ransack_params)
    pagy_params = { page: params[:page] || 1, items: 10 }
    result = GenericCrudInteractor.call(
      model: User,
      action: :fetch,
      ransack_params: ransack_params,
      pagy_params: pagy_params
    )
    @pagy = result.pagy
    @records = result.records
    @ransack = User.ransack(ransack_params)
    render
  end

  def new
    @user = User.new
    render layout: false
  end

  def create
    result = GenericCrudInteractor.call(
      model: User,
      action: :create,
      params: user_params
    )
    if result.success?
      redirect_to users_path, notice: "User created"
    else
      @user = User.new(user_params)
      @user.errors.add(:base, result.error)
      render :new, status: :unprocessable_entity, layout: false
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
    params.require(:user).permit(:email)
  end
end
