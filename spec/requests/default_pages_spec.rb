require 'spec_helper'

describe "DefaultPages" do
  subject { page }
  describe "Home page" do
    before { visit root_path }
    it { should have_selector('h1', :text => "BrainStorm") }
    it { should have_selector('title', :text => "BrainStorm") }
    it { should_not have_selector('title', :text => "Home") }
  end

  describe "Admin Page" do
    before { visit admin_path }
    it { should have_selector('h1', :text => "Admin Panel") }
    it { should have_selector('title', :text => "BrainStorm | Admin Panel") }
  end

  describe "LeaderBoard Page" do
    before { visit fame_path }
    it { should have_selector('h1', :text => "LeaderBoard") }
    it { should have_selector('title', :text => "BrainStorm | LeaderBoard") }
  end

  describe "Contact page" do
    before { visit contact_path }
    it { should have_selector('title', :text => "Contact Us") }
    it { should have_selector('h1', :text => "Contact") }
  end
end
