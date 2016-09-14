class User < ActiveRecord::Base
  attr_accessor :remember_token
  
	 before_save { self.email = email.downcase }
	  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                     uniqueness: { case_sensitive: false }
has_secure_password
validates :password, presence: true, length: { minimum: 6 },allow_nil: true
def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #tạo chuỗi ngẫu nhiên cho cookies 
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  #lưu chuỗi này vào csdl
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest,User.digest(remember_token))
  end

  #kiểm tra chuỗi này có đúng hay ko
  def authenticated?(remember_token)
    if remember_digest.nil?
      false
    else
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
  end

  # xóa cookies, đưa chuỗi đó về null
  def forget
    update_attribute(:remember_digest, nil)
  end

 
  

end
