module UserHelper
  def get_roles
    User.roles.reject { |k,v| k=="admin" }.keys.map {|role| [role.titleize,role]}
  end
end
