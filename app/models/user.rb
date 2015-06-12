class User < ActiveRecord::Base
  def self.current_user
    Thread.current[:current_user]
  end

  def self.current_user=(usr)
    Thread.current[:current_user] = usr
  end

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  validate :check_role, if: :other_roles

  belongs_to :company
  has_many :invoices, through: :company
  has_many :clients, through: :company

  enum role: [:auditor, :accountant, :manager, :admin]

  after_commit :make_admin!

  def after_confirmation
    send_reset_password_instructions unless admin?
  end

  def colleagues
    company.users.where.not(role: User.roles[:admin])
  end

  def make_admin!
    unless role.present?
      self.admin!
    end
  end

   def other_roles
     User.current_user.admin? if User.current_user.present?
   end

  def check_role
    errors.add(:role, "Please select a role") unless (User.roles).include?(role)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

end

