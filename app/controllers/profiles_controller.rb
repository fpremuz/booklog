class ProfilesController < ApplicationController
  def show
    @user = User.find_by(username: params[:username])
    if Current.session.user == @user
      @books = @user.books.order(:title)
    else
      @books = @user.books.where(public: true).order(:title)
    end
  end

  def edit
    @user = Current.session.user
  end
  
  def update
    @user = Current.session.user
    if @user.update(user_params)
      flash[:notice] = "Profile updated successfully"
      redirect_to profile_path(@user.username), notice: "Profile updated"
    else
      flash[:alert] = "Failed to update profile"
      render :edit, status: :unprocessable_entity
    end
  end

  def share
    @user = User.find_by(username: params[:username])
    if @user.nil?
      redirect_to root_path, alert: "User not found"
    else
      shareable_url = profile_url(@user.username)
      flash[:notice] = "Share this profile: '#{shareable_url}'".html_safe
      redirect_to profile_path(@user.username)
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :username, :password, :password_confirmation)
    end

end