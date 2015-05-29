# http://stackoverflow.com/questions/4101641/rails-devise-handling-devise-error-messages
module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?
    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    html = <<-HTML
    <div class="alert alert-danger alert-dismissible">
      <button type="button" data-dismiss="alert" class="close" aria-hidden="true">×</button>
      <div id="flash_alert">
        #{messages}
      </div>
    </div>
    HTML

    html.html_safe
  end
end