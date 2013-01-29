require 'spec_helper'

describe "User pages" do
  describe "forms - " do
    subject { page }
    describe "Registration form" do
      before { visit new_user_registration_path }
      it { should have_selector('title', :text => "BrainStorm | User Registration") }
      it { should have_selector('h1', :text => "Sign up") }
    end
  end
end
