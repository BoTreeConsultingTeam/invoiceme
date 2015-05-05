module ApplicationHelper

  def top_navbar_active_class_name(r_controller_name, r_action_name)
    controller_name == r_controller_name && action_name == r_action_name ? 'active' : ''
  end

  def is_admin?
    current_user.present? && current_user.role.to_s == 'Admin'
  end

end
