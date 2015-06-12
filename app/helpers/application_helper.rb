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

  def formatted_address(record)
    if record.address.present?
      simple_format("#{record.address.street_1} #{record.address.street_2}, \n#{record.address.city}, #{record.address.state}, \n#{record.address.pincode}")
    end
  end

  def active_page_class(controller,action1,action2)
    case controller == controller_name
      when true
        case controller
          when 'user'
            if (action_name == "change_password" || action_name == "update_password") && (action1 == "change_password" && action2 == "update_password")
              'active'
            elsif action_name != "change_password" && action_name != "update_password" && action1 == "" && action2 == ""
              'active'
            else
              ''
            end
          when 'invoices'
            'active'
          when 'home'
            'active'
          when 'clients'
            'active'
          when 'items'
            'active'
          when 'taxes'
            'active'
          when 'company'
            'active'
          when 'registrations'
            'active'
          else
            ''
        end
      when false
        ''
    end
  end
end
