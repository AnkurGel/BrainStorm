require 'spec_helper'

describe "DefaultPages" do
  subject { page }

  shared_examples_for "default page" do
    it { should have_selector('title', :text => complete_title(page_title)) }
    it { should have_selector('h1', :text => heading) }
  end
  describe "Home page" do
    before { visit root_path }
    let(:page_title) { "" }
    let(:heading) { "BrainStorm" }
    it_should_behave_like "default page"
    it { should_not have_selector('title', :text => "Home") }
    it { should_not have_link("Admin", :href => admin_path) }
    it { should have_link("Signin", :href => new_user_session_path) }
  end

  describe "Admin Page" do
    before { visit admin_path }
    let(:page_title) { "Admin Panel" }
    let(:heading) { "Admin Panel" }
    it_should_behave_like "default page"
  end

  describe "LeaderBoard Page" do
    before { visit fame_path }
    let(:page_title) { "LeaderBoard" }
    let(:heading) { "LeaderBoard" }
    it_should_behave_like "default page"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:page_title) { "Contact Us" }
    let(:heading) { "Contact" }
    it_should_behave_like "default page"
  end
end
