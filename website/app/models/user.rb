class User < ApplicationRecord
    enum role: [:student, :faculty, :admin]
    after_initialize :set_default_role, :if => :new_record?
    
    def set_default_role
        self.role ||= :student
    end
    before_save { self.email = email.downcase }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, presence: true, length: { minimum: 3 }, allow_nil: true
    validates :first, presence: true
    validates :last, presence: true
end
