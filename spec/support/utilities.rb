def complete_title(title)
  base_title = "BrainStorm"
  if title.empty?
    base_title
  else
    "#{base_title} | #{title}"
  end
end

def signin(user)
  visit login_path
  fill_in "Email", :with => user.email
  fill_in "Password", :with => user.password
  click_button "Sign in"
end
