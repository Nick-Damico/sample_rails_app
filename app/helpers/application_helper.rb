module ApplicationHelper

  def full_title(page_title = '')
    app_title = "Ruby on Rails: Sample App"
    page_title.empty? ? app_title : "#{page_title} | #{app_title}"
  end

  def display_flash(flash)
    if flash.any?
      flash.each do |message_type, message|
        return content_tag(:div, message, class: "alert alert-#{message_type}")
      end
    end
  end
end
