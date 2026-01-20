class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { read_only: 0, admin: 1, reviewer: 2 }, suffix: true

  def admin?
    admin_role?
  end

  def read_only?
    read_only_role?
  end

  def reviewer?
    reviewer_role?
  end
end