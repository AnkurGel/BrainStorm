require 'spec_helper'

describe "User pages" do
  describe "forms - " do
    subject { page }

    describe "Registration page" do
      before { visit new_user_registration_path }
      it { should have_selector('title', :text => complete_title("User Registration")) }
      it { should have_selector('h1', :text => "Sign up") }
    end

    describe "signup" do
      before { visit new_user_registration_path }
      let(:submit) { "Sign Up" }

      describe "with invalid information" do
        before { click_button submit }
        it { should have_content("error") }
        it { should have_selector("li", :text => "Email can't be blank") }
        it { should have_selector("li", :text => "Password can't be blank") }
      end

      describe "with valid information" do
        before do
          fill_in "Email", :with => "foobar@foo.com"
          fill_in "Password", :with => "foobar"
          fill_in "Password confirmation", :with => "foobar"
        end
        it "should create a user" do
          click_button submit
          should have_content("You have signed up successfully")
#          expect { click_button submit }.to change(User.count).by(1)
        end

        describe "after creating a user" do
          before { click_button submit }
          it { should have_link("SignOut", :href => destroy_user_session_path) }
          describe "clicks to sign out" do
            before { click_link "SignOut" }
            it { should have_content("Signed out successfully") }
          end
        end
      end
    end
  end
end
