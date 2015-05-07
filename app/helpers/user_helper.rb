module UserHelper
  USER_ROLES_EXCEPT_ADMIN = User.roles.except(:admin)
  def get_roles
    USER_ROLES_EXCEPT_ADMIN.keys.map {|role| [role.titleize,role]}
  end
end
