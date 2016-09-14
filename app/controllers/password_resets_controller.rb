class PasswordResetsController < ApplicationController
	before_action :get_user,   only: [:edit, :update]
  	before_action :valid_user, only: [:edit, :update]
	before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def edit
  end

  def update
  	if params[:user][:password].empty?
  		@user.errors.add(:password, "không được bỏ trống")
  		render 'edit'
  	elsif @user.update_attributes(user_params)
  		log_in @user
  		flash[:success] = "Password đã được thay đổi"
  		redirect_to @user
  	else
  		render 'edit'
  	end

  end

  def create
  	@user = User.find(email: params[:password_reset][:email].downcase)
  	if @user
  		@user.create_reset_digest
  		@user.send_password_reset_email
  		flash[:info] = "Mật khẩu mới đã được gửi đi trong email của bạn"
        redirect_to root_url
    else
    	 flash.now[:danger] = "Email này không tồn tại"
      	 render 'new'
    end
  end
  private
   def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

  def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    #kiểm tra thời gian tối đa reset pass
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
