class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    credentials = [user_params[:username], user_params[:password]]
    @user = User.find_by_credentials(*credentials)

    if @user
      login!(@user)
      flash[:notices] = ["Welcome #{@user.username}!"]
      redirect_to user_url(@user)
    else
      flash.now[:errors] = ['Invalid credentials']
      render :new
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

end