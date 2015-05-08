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
    send_reset_password_instructions unless admin? && admin_id == id
  end

  def colleagues
    if company.present?
      company.users.where.not(role: User.roles[:admin])
    else
      User.where("role <> ?",User.roles[:admin]).where(admin_id: id).where.not(id: id)
    end
  end

  def make_admin!
    if role.nil? && admin_id.nil?
      user = User.find_by(admin_id: id)
      unless user.present? && user.admin?
        self.admin_id = id
        self.role = self.class.roles[:admin]
        self.save
      end
    end
  end

  def other_roles
    ((admin_id.present?) && (admin_id != id))
  end

  def check_role
    errors.add(:role, "is not valid, please select a valid role.") unless (User.roles).include?(role)
  end

end
