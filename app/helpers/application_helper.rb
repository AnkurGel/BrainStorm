module ApplicationHelper
  def alert_active(param, value)
    "active" if params[param].eql? value
  end

  def if_this_is_you(user)
    if current_user and current_user.eql?(user)
      "highlight_user"
    else
      ""
    end
  end
  def insert_title(title)
    base_title = "BrainStorm"
    if title.empty?
      base_title
    else
      "#{base_title} | #{title}"
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id         = new_object.object_id
    fields     = f.fields_for(association, new_object, child_index: id) do |builder|
      render("default_pages/" + association.to_s.singularize + "_fields", :f => builder)
    end
    link_to(name, '#', class: "add_fields", data: {:id => id, :fields => fields.gsub("\n", "")})
  end

  def image_for(user, with_class = "")
    if user.image
      image_url = user.image
    else
      g_id      = Digest::MD5::hexdigest(user.email.downcase)
      image_url = "https://secure.gravatar.com/avatar/#{g_id}"
    end
    image_tag(image_url, :alt => "Image",
              :class => "profile_image img-polaroid #{with_class}")
  end
end
