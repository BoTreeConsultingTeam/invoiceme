module ApplicationHelper
  BOOTSTRAP_ALERT_CLASSES_MAPPING = { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }
  def top_navbar_active_class_name(r_controller_name, r_action_name)
    controller_name == r_controller_name && action_name == r_action_name ? 'active' : ''
  end

  def bootstrap_class_for(flash_type)
     BOOTSTRAP_ALERT_CLASSES_MAPPING[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible", role: 'alert') do
        concat(content_tag(:button, class: 'close', data: { dismiss: 'alert' }) do
          concat content_tag(:span, '&times;'.html_safe, 'aria-hidden' => true)
          concat content_tag(:span, 'Close', class: 'sr-only')
        end)
        concat message
      end)
    end
    nil
  end

  def is_admin?
    current_user.present? && current_user.admin?
  end

  def format_date(date, format = "%m/%d/%Y")
      date.strftime(format)
  end

  def current_company
    current_user.company
  end
end
