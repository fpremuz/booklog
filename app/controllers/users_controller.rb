class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  before_action :set_user, only: [:edit, :update]

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

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Profile updated successfully.'
    else
      render :edit
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :username)
    end

    def set_user
      @user = Current.session.user
    end

end
