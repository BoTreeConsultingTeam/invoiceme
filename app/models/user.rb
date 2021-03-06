class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Validations
  validates :role, presence: true, if: :other_roles
  validate :check_role, if: :other_roles

  ## Associations
  belongs_to :company
  has_many :invoices, through: :company
  has_many :clients, through: :company

  ## Constants
  ROLES = ["auditor", "accountant", "manager"]

  ## Callbacks
  after_create :assign_role_and_admin_id

  # Override Devise::Confirmable#after_confirmation
  def after_confirmation
    send_reset_password_instructions if not_admin_user?
  end

  def assign_role_and_admin_id
    if (role.nil? && admin_id.nil?)
      user = User.find_by(role: "Admin", admin_id: id)
      update_columns(role: "Admin", admin_id: id) if user.nil?
    end
  end

  def other_roles
    ((admin_id.present?) && (admin_id != id))
  end

  def check_role
    errors.add(:role, "is not valid, please select a valid role.") unless (User::ROLES).include?(role)
  end

  def not_admin_user?
    ((role != "Admin") && (admin_id != id))
  end

end
