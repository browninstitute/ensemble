module ApplicationHelper
  
  # Enables nested layouts.
  # http://m.onkey.org/nested-layouts-in-rails-3
  def parent_layout(layout)
    @view_flow.set(:layout, output_buffer)
    self.output_buffer = render(:file => "layouts/#{layout}")
  end
  
  def timeago(time, options = {})
    options[:class] ||= "timeago"
    content_tag(:abbr, time.to_s, options.merge(:title => time.getutc.iso8601)) if time
  end
end
