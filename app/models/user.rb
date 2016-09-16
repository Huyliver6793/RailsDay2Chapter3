class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest
	before_save :downcase_email


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

  # sử dụng tìm kiếm id trong sql, câu lệnh này để tránh lỗi SQL injection
  def feed
    Micropost.where("user_id = ?", id)
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

  
  # trả về true nếu token này phù hợp
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # kích hoạt tài khoản
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # gửi email kích hoạt
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
    
  end

  # xóa cookies, đưa chuỗi đó về null
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Thiết lập password cần reset
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Gửi email thiết lập lại mật khẩu
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # trả về true nếu thời gian để thiết lập lại mật khẩu hết hạn
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
 public
  def create_activation_digest
     self.activation_token  = User.new_token
     self.activation_digest = User.digest(activation_token)
  end

  def downcase_email 
    self.email = email.downcase
  end
end
