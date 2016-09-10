module SessionsHelper
	def login_in(user)
		session[:user_id] = user_id
	end
	def current_user
  		User.find_by(id: session[:user_id])
 	end
  end
end
