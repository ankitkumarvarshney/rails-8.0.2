class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
  validates :password, presence: true, if: -> { new_record? || !password.nil? }
  validates :password_confirmation, presence: true, if: -> { new_record? || !password.nil? }

  # Associations
  has_many :posts, dependent: :destroy

  # Instance methods
  def full_name
    "#{first_name} #{last_name}".strip
  end

  def to_s
    full_name.presence || email
  end
end
