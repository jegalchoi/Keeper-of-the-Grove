class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    find_user_by_params_id

    if @user
      render :show
    else
      render :index
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login!(@user)
      flash[:notices] = ["You have successfully signed up!"]
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def find_user_by_params_id
    @user = User.find_by(id: params[:id])
  end

end