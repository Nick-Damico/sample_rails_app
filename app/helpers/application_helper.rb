module ApplicationHelper

  def full_title(page_title = '')
    app_title = "Ruby on Rails: Sample App"
    page_title.empty? ? app_title : "#{page_title} | #{app_title}"
  end

end
