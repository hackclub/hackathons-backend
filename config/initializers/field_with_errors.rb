Rails.application.configure do
  config.action_view.field_error_proc = proc do |html_tag, instance|
    if !/^input/.match?(html_tag)
      html_tag
    elsif (class_attribute_index = html_tag.index('class="'))
      html_tag.insert(class_attribute_index + 7, "field_with_errors ")
    elsif html_tag.index("/>")
      html_tag.insert(html_tag.index("/>"), " class=field_with_errors ")
    else
      html_tag.insert(html_tag.index(">"), " class=field_with_errors ")
    end
  end
end
