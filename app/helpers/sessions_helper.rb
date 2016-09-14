module SessionsHelper
	def log_in(user)
		session[:user_id] = user.id
	end
 	def logged_in?
 		!current_user.nil?	
 	end
 	  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  	end

    # lưu cookies cho 1 người dùng
  	def remember(user)
  		user.remember
  		cookies.permanent.signed[:user_id] = user.id 	
    	cookies.permanent[:remember_token] = user.remember_token
  	end

    # trả lại thông tin người sử dụng tương ứng vs cookies đã lưu
  	def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  	end
  	def forget(user)
  		user.forget
  		cookies.delete(:user_id)
  		cookies.delete(:remember_token)
  	end

    # kiểm tra người dùng nhập vào có phải người dùng đang ở phiên hoạt động đó hay ko
    def current_user?(user)
      user == current_user
    end

    # Chuyển hướng đến vùng lưu trữ hoặc mặc định
    def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
    end

    # 1 nhóm url được  truy cập
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
