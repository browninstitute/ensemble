module PostsHelper

  def nested_posts(posts)
    posts.map do |post, sub_posts|
      render(post) + content_tag(:div, nested_posts(sub_posts), :class => "nested_post")
    end.join.html_safe
  end

end
