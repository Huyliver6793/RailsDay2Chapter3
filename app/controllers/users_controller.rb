class UsersController < ApplicationController
  before_action :logged_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  

  # index
  def index
    @users = User.paginate(page: params[:page])
  end

  # tạo 1 user mới
  def new
  	@user= User.new
  end

  
  # sửa
  def edit
    @user = User.find(params[:id])
  end

  # kiếm tra người dùng đăng nhập hay chưa
  def logged_user
    unless logged_in?
      store_location
      flash[:danger] = "Bạn phải đăng nhập"
      redirect_to login_url
    end
  end

  # kiểm tra có đúng người dùng hay không
  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end

  #update
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Thay đổi tài khoản thành công"
      redirect_to current_user
    else
      render 'edit'
    end
  end

  # xóa
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "xóa thành công"
    redirect_to users_url
  end
  

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      ##UserMailer.account_activation(@user).deliver_now
      @user.send_activation_email
      flash[:info] = "Kiếm tra email để kích hoạt tài khoản"
      redirect_to root_url
  	else
  		render 'new'
  	end
  end
 
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
   def admin_user
    redirect_to(root_url) unless current_user.try(:admin?)
  end
  
end
