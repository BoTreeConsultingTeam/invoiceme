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
  enum role: [:auditor, :accountant, :manager, :admin]

  ## Callbacks
  after_commit :make_admin!

  # Override Devise::Confirmable#after_confirmation
  def after_confirmation
    send_reset_password_instructions unless admin?
  end

  def colleagues
    company.users.where.not(role: User.roles[:admin])
  end

  def make_admin!
    unless role.present?
      self.role = self.class.roles[:admin]
      self.save
    end
  end

  def other_roles
    admin?
  end

  def check_role
    errors.add(:role, "is not valid, please select a valid role.") unless (User.roles).include?(role)
  end

end

