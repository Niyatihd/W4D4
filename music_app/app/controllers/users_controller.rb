class UsersController < ApplicationController

  def new
    render :new #render the new.html.erb view to sign up
  end
  
  def show
    @user = User.find_by(params[:id])

    render json: @user
  end

  def create
    @user = User.new(user_params)
    if @user.save!
      login!(@user)
      redirect_to #######
    else
      render json: @user.errors.full_messages
    end

  end


  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end