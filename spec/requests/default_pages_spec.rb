require 'spec_helper'

describe "DefaultPages" do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  shared_examples_for "any other page" do
    it { should have_selector('title', :text => complete_title(page_title)) }
    it { should have_content(heading) }
  end

  describe "Home page" do
    before { visit home_path }
    describe "when visited as general user" do
      let(:page_title) { "Avensis 2013" }
      let(:heading) { "BrainStorm" }
      it_should_behave_like "any other page"
      it { should_not have_selector('title', :text => "Home") }
      it { should_not have_link("Admin",     :href => admin_path) }
      it { should have_link("Signin",        :href => new_user_session_path) }
    end
    describe "when visited with administrator previledge" do
      before { signin(admin) }
      it { should have_link("Analytics", :href => analytics_path) }
      it { should have_link("Admin", :href => admin_path) }
    end
  end

  describe "Admin Page" do
    before { visit admin_path }
    describe "when visited as general user" do
      let(:page_title) { "Avensis 2013" }
      let(:heading) { "BrainStorm" }
      it_should_behave_like "any other page"
      it { should have_selector('.alert.alert-notice', :text => "sudo says: YOU SHALL NOT PASS!") }
    end
    describe "when visited with administrator previledge" do
      before do
        signin(admin)
        visit admin_path
      end
      let(:page_title) { "Admin Panel" }
      let(:heading) { "Admin Panel" }
      it_should_behave_like "any other page"
      it { should_not have_link("Signin", :href => new_user_session_path) }
    end
  end

  describe "LeaderBoard Page" do
    before { visit fame_path }
    describe "when visited as general user" do
      let(:page_title) { "LeaderBoard" }
      let(:heading) { "LeaderBoard" }
      it_should_behave_like "any other page"
      it { should have_selector('th', :text => 'Position') }
      it { should have_selector('th', :text => 'Name') }
      it { should have_selector('th', :text => 'College') }
      it { should have_selector('th', :text => '#Score') }
    end
    describe "when visited with administrator previledge" do
      before do
        signin(admin)
        visit fame_path
      end
      let(:page_title) { "LeaderBoard" }
      let(:heading) { "LeaderBoard" }
      it_should_behave_like "any other page"
      it { should have_selector('th', :text => 'Position') }
      it { should have_selector('th', :text => 'User') }
      it { should have_selector('th', :text => 'Name') }
      it { should have_selector('th', :text => 'College') }
      it { should have_selector('th', :text => 'Score') }
    end
  end

  describe "Team page" do
    before { visit team_path }
    let(:page_title) { "Super Team" }
    let(:heading) { "Team" }
    it_should_behave_like "any other page"
  end

  describe "Analytics page" do
    before { visit analytics_path }
    describe "when visited as general user" do
      let(:page_title) { "Avensis 2013" }
      let(:heading) { "BrainStorm" }
      it_should_behave_like "any other page"
      it { should have_selector('.alert.alert-notice', :text => "sudo says: YOU SHALL NOT PASS!") }
    end
    describe "when visited with administrator previledge" do
      before do
        signin(admin)
        visit analytics_path
      end
      let(:page_title) { "Analytics Board" }
      let(:heading) { "" }
      it_should_behave_like "any other page"
      ["Hide/Show Registration/Day chart", "Hide/Show colleges' scores and registrations chart", "Hide/Show colleges' participation% chart",
       "Hide/Show Facebook/Manual signups", "Hide/Show colleges' frequent sign-ins chart", "Hide/Show Level vs Attempts chart",
       "Hide/Show Attempts per level pie", "Hide/Show Attempts per level pie"
      ].each do |chart|
        it { should have_content(chart) }
      end
    end
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:page_title) { "Contact Us" }
    let(:heading) { "Contact Us" }
    it_should_behave_like "any other page"
  end
end
