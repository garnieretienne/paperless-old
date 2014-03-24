module ApplicationHelper

  # Render a partial view inside the specified JQuery selector.
  # If no selector is given, it will use `the data-name-of-controller` synthax.
  def render_using_javascript(partial, jquery_selector = nil, locals = {})
    jquery_selector ||= "[data-#{controller.action_name.gsub("_", "-")}]"
    coffee_code = <<-EOS

    if $("#{jquery_selector}").length
      $('#{jquery_selector}').html "#{escape_javascript(render(partial: partial, locals: locals))}"
      $(document).trigger "page:change"

    EOS
    coffee_code.html_safe
  end
end
