require 'spec_helper'

describe "Admin pages" do
  subject { page }
  let(:admin) { FactoryGirl.create(:admin) }
  before { @user = FactoryGirl.create(:user) }

  describe "Admin" do
    describe "when signs in" do
      before { visit login_path }
      describe "form when filled with valid admin credentials" do
        before do
          fill_in "Email",    :with => admin.email
          fill_in "Password", :with => admin.password
          click_button "Sign in"
        end
        it { should have_content("Signed in successfully.") }
        it { should_not have_link("Signin",  :href => new_user_session_path) }

        describe "should see special admin pages" do
          it { should have_link('Analytics', :href => analytics_path) }
          it { should have_link('Admin',     :href => admin_path) }
        end

        describe "visits Analytics page" do
          before { visit analytics_path }
          it "should not restrict the access" do
            should_not have_content("sudo says: YOU SHALL NOT PASS!")
          end
          it { should have_content(admin.name) }
          it { should have_selector('title', :text => complete_title("Analytics Board")) }
          it { should have_content("Hide/Show Registration/Day chart") }
        end

        describe "visits LeaderBoard" do
          before { visit fame_path }
          it "should not restrict the access" do
            should_not have_content("sudo says: YOU SHALL NOT PASS!")
          end
          describe 'should see some extra fields' do
            it { should have_selector('th',   :text => 'User') } #contains email
            it { should have_link('Kick',     :href => user_destroy_path(@user)) }
            it { should have_link('View',     :href => view_attempts_path(@user)) }
            it { should have_link('|Analyze', :href => observe_get_path(@user)) }
          end
        end

        describe "visits Admin panel page" do
          before { visit admin_path }
          it "should not restrict the access" do
            should_not have_content("sudo says: YOU SHALL NOT PASS!")
          end
          it { should have_selector('title', :text => complete_title("Admin Panel")) }
          it { should have_selector('h1',    :text => 'Admin Panel') }
          it { should have_content('Add Level') }
          it { should have_content('Add/Edit hint') }
          it { should have_content('Add link of Music file') }
          it { should have_content('Add Image') }
          it { should have_content('Create College') }
        end
      end
    end
  end
end
