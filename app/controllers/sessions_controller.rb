class SessionsController < ApplicationController
  layout "sessions"
  skip_before_action :authenticate, only: %i[ new create ]

  before_action :set_session, only: :destroy

  def index
    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  def new
  end

  def create
    if user = User.authenticate_by(email: params[:email], password: params[:password])
      @session = user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }

      redirect_to root_path, notice: "Signed in successfully"
    else
      redirect_to sign_in_path(email_hint: params[:email]), alert: "That email or password is incorrect"
    end
  end

  def destroy
    @session.destroy; redirect_to(sessions_path, notice: "That session has been logged out")
  end

  def omniauth
    user = User.from_omniauth(request.env["omniauth.auth"])

    if user.persisted?
      session[:user_id] = user.id
      redirect_to root_path, notice: "Signed in with #{user.provider.titleize}"
    else
      redirect_to login_path, alert: "Authentication failed."
    end
  end

  private
    def set_session
      @session = Current.user.sessions.find(params[:id])
    end
end
