require 'spec_helper'

describe "Authorization" do
  subject { page }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:user) { FactoryGirl.create(:user) }

  describe "when not logged in user visits the site" do
    before { visit home_path }
  end

  describe "when general user visits the site" do
    before { visit login_path }
    describe "and signs in" do
      before do
        fill_in "Email",    :with => user.email
        fill_in "Password", :with => user.password
        click_button "Sign in"
      end
      it { should have_content("Signed in successfully.") }

      describe "and tries to access admin panel" do
        before { visit admin_path }
        it { should have_selector('.alert.alert-notice', :text => "sudo says: YOU SHALL NOT PASS!") }
        it { should_not have_selector('title',           :text => complete_title('Admin Panel')) }
        it { should_not have_selector('h1',              :text => 'Admin Panel') }
        it "should be on home page" do
          should have_content("What's in it for me?")
        end
      end

      describe "and tries to access analytics board" do
        before { visit analytics_path }
        it { should have_selector('.alert.alert-notice', :text => "sudo says: YOU SHALL NOT PASS!") }
        it { should_not have_selector('title', :text => complete_title('Analytics Board')) }
        it "should be on home page" do
          should have_content("What's in it for me?")
        end
      end

      describe "and visits leaderboard page" do
        before { visit fame_path }
        it { should have_selector('title',  :text => complete_title('LeaderBoard')) }
        it { should have_selector('h1',     :text => 'LeaderBoard') }
        it { should_not have_selector('th', :text => 'User') }
        it { should_not have_content('Kick') }
        it { should_not have_content('View') }
        it { should_not have_content('|Analyze') }
      end
    end
  end

  describe "when admin of site visits the site" do
    before { visit login_path }

    describe "and signs in" do
      before do
        fill_in "Email",    :with => admin.email
        fill_in "Password", :with => admin.password
        click_button "Sign in"
      end
      it { should have_content("Signed in successfully.") }

      describe "and tries to access admin panel" do
        before { visit admin_path }
        it { should_not have_selector('.alert.alert-notice', :text => "sudo says: YOU SHALL NOT PASS!") }
        it { should have_selector('title',           :text => complete_title('Admin Panel')) }
        it { should have_selector('h1',              :text => 'Admin Panel') }
        it "should not be on home page" do
          should_not have_content("What's in it for me?")
        end
      end
      describe "and tries to access analytics board" do
        before { visit analytics_path }
        it { should_not have_selector('.alert.alert-notice', :text => "sudo says: YOU SHALL NOT PASS!") }
        it { should have_selector('title', :text => complete_title('Analytics Board')) }
        it "should not be on home page" do
          should_not have_content("What's in it for me?")
        end
      end
      describe "and visits leaderboard page" do
        #let is lazy, user won't be present here anymore.
        before { @user = FactoryGirl.create(:user); visit fame_path }
        it { should have_selector('title',  :text => complete_title('LeaderBoard')) }
        it { should have_selector('h1',     :text => 'LeaderBoard') }
        it { should have_selector('th', :text => 'User') }
        it { should have_content('Kick') }
        it { should have_content('View') }
        it { should have_content('|Analyze') }
      end
    end
  end
end
