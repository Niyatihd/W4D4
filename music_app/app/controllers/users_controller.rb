class UsersController < ApplicationController

  def index
    @users = User.all
    render :index
  end

  def new
    @user = User.new 
    render :new #render the new.html.erb view to sign up
  end
  
  def show #only used to show that a user logged in in sessions_controller.rb
    @user = User.find(params[:id])
    render :show
  end

  def create
    @user = User.new(user_params)

    if @user.save!
      login!(@user)
      redirect_to users_url
    else
      redirect_to new_user_url
    end

  end


  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end