def complete_title(title)
  base_title = "BrainStorm"
  if title.empty?
    base_title
  else
    "#{base_title} | #{title}"
  end
end
