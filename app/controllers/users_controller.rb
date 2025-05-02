class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for(@user) 
      puts @user.errors.full_messages
      redirect_to books_path, notice: "Account created successfully!"
    else
      puts @user.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

end
