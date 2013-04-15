require 'spec_helper'

describe "Authentication pages" do
  describe "forms - " do
    subject { page }

    describe "Registration page" do
      before { visit new_user_registration_path }
      it { should have_selector('title', :text => complete_title("User Registration")) }
      it { should have_selector('h1',    :text => "Sign up") }
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
          fill_in "Name",                  :with => "Foo Bar"
          fill_in "Email",                 :with => "foobar@foo.com"
          fill_in "Password",              :with => "foobar"
          fill_in "Password confirmation", :with => "foobar"

        end
        it "should create user and sign in successfully" do
          click_button submit
          should have_content("Welcome! You have signed up successfully.")
        end
        it "should create a new user" do
          expect { click_button submit }.to change(User, :count).by(1)
        end

        describe "after creating a user" do
          before { click_button submit }
          it { should have_link("SignOut", :href => destroy_user_session_path) }
        end
      end
    end

    describe "Login page" do
      before { visit login_path }
      it { should have_selector('title', :text => complete_title('Sign in')) }
      it { should have_selector('h1',    :text => 'Sign in') }
      it { should have_selector('label', :text => 'Email') }
      it { should have_selector('label', :text => 'Password') }
      it { should have_button("Sign in") }
      it { should have_link("Sign up",   :href => new_user_registration_path) }
    end

    describe "login process" do
      let(:user) { FactoryGirl.create(:user) }
      before { visit login_path }

      describe "form when filled with invalid credentials" do
        before do
          fill_in "Email",    :with => "ankurgel@gmail.com"
          fill_in "Password", :with => "wrongpassword"
          click_button "Sign in"
        end
        it { should have_selector('div.alert', :text => "Invalid email or password.") }
        describe "should still be on Signin page" do
          it { should have_selector('title', :text => complete_title('Sign in')) }
          it { should have_selector('h1',    :text => 'Sign in') }
        end
        it "should still have signin link" do
          should have_link('Signin', :href => new_user_session_path)
        end
      end

      describe "form when filled with valid information" do
        let(:user) { FactoryGirl.create(:user) }
        before do
          fill_in "Email",    :with => user.email
          fill_in "Password", :with => user.password
          click_button "Sign in"
        end
        it { should have_content("Signed in successfully.") }
        it { should_not have_link("Signin", :href => new_user_session_path) }
      end
    end
  end
end
