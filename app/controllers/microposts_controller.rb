class MicropostsController < ApplicationController
before_action :logged_user, only: [:creare, :destroy]
before_action :correct_user,   only: :destroy  # kiểm tra người dùng trước khi thực hiện action

def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = [] # nếu khi mình tạo 
      render 'static_page/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:sucess] = "Bài viết đã được xóa"
    # request.referrer dùng để request về trang mà trước khi mình xóa, 
    #nếu ko tồn tại trang đó thì về trang root
    redirect_to request.referrer || root_url 

  end
private 
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

      # kiểm tra micropost thông qua user xem có tồn tại micropost hay ko,
      # sau đó trả về trang chủ nếu ko tồn tại 
     def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

end
