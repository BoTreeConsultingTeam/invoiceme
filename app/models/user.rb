class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Associations
  belongs_to :company
  has_many :invoices, through: :company
  has_many :clients, through: :company

  ## Callbacks
  after_create :assign_role_and_admin_id

  def assign_role_and_admin_id
    if (self.role.nil? and self.admin_id.nil?)
      user = User.find_by(:role => "Admin", :admin_id => self.id)
      if user.nil?
        self.update_column(:role, "Admin")
        self.update_column(:admin_id, self.id)
      end
    end
  end

end
