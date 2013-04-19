require 'spec_helper'
require 'ruby-debug'
describe DefaultPagesController do

  subject { response }
  describe "GET #home" do
    it "renders the :home view" do
      get :home
      should render_template :home
    end
    it "lists @level_attempts if user is signed in" do
      FactoryGirl.create(:playable_game)
      user = FactoryGirl.create(:user)
      FactoryGirl.create_list(:attempt, 10, :user_id => user, :level_id => 1)
      sign_in(user)
      get :home
      expect(assigns(:level_attempts)).to eq [Attempt.level_attempt_chart_data(user).first.stringify_keys]
    end
  end

  describe "GET #fame" do
    it "renders the :fame view" do
      get :fame
      should render_template :fame
    end
    it "gets assigned correct page number to show" do
      get :fame, :page => '2'
      expect(assigns(:page)).to eq 1
    end
  end

  describe "GET #contact" do
    it "renders the :contact view" do
      get :contact
      should render_template :contact
    end
  end

  describe "GET #team" do
    it "renders the :team view" do
      get :team
      should render_template :team
    end
  end

  describe "GET #rules" do
    it "renders the :rules view" do
      get :rules
      should render_template :rules
    end
  end

  describe "GET #policy" do
    it "renders the :policy view" do
      get :policy
      should render_template :policy
    end
  end

  describe "GET #analytics" do
    it "redirects to #home if not signed in" do
      get :analytics
      should redirect_to home_path
    end

    context "when signed in as admin" do
      before do
        @admin = FactoryGirl.create(:admin)
        sign_in(@admin)
      end
      it "should render analytics page" do
        get :analytics
        should render_template :analytics
      end
      it "should have correctly assigned @registrations JSON data" do
        FactoryGirl.create(:second_user)
        get :analytics
        expect(assigns(:registrations)).to eq [User.registration_data.first.stringify_keys]
      end
      it "should have correctly assigned @colleges JSON data" do
        FactoryGirl.create(:second_user)
        get :analytics
        expect(assigns(:colleges)).to eq User.colleges_bar_chart_data.map{ |x| x.stringify_keys}
      end
      it "should have correctly assigned @users JSON data" do
        get :analytics
        expect(assigns(:users)).to match_array User.order('score DESC')
      end
      it "should have correct assigned @level_attempts JSON data" do
        get :analytics
        expect(assigns(:level_attempts)).to match_array Attempt.level_attempt_chart_data(@admin)
      end
      it "should have correctly assigned FB and NON FB users data" do
        get :analytics
        expect(assigns(:fb_non_fb_users)).to eq User.fb_non_fb_users_data.map{|x| x.stringify_keys}
      end
    end

    context "redirects to #home if signed in as general user" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in(@user)
        get :analytics
      end
      it { should redirect_to :home }
    end
  end

  describe "GET #admin" do
    it "redirects to #home  if not signed in" do
      get :admin
      should redirect_to home_path
    end

    context "renders the :admin view if signed in as admin" do
      before do
        @admin = FactoryGirl.create(:admin)
        sign_in(@admin)
        get :admin
      end
      it { should render_template :admin }
      it "should assign a new level to @level" do
        expect(assigns(:level)).to be_a_new Level
      end
      it "should assign all users to @users" do
        expect(assigns(:users)).to match_array User.all
      end
      it "should assign a new college to @college" do
        expect(assigns(:college)).to be_a_new College
      end
    end

    context "redirects to #home if signed in as general user" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in(@user)
        get :admin
      end
      it { should redirect_to :home }
    end
  end

  describe "GET #view_attempts" do
    before(:all) do
      @user = FactoryGirl.create(:user)
      @admin = FactoryGirl.create(:admin)
    end
    it "should redirect to #home if not signed in" do
      get :view_attempts, id: 1
      expect(response).to redirect_to :home
    end

    it "should redirect to #home if signed in as general user" do
      sign_in(@user)
      get :view_attempts, id: 1
      expect(response).to redirect_to :home
    end

    it "should render :view_attempts page if signed in as admin" do
      sign_in(@admin)
      get :view_attempts, id: 1
      expect(response).to render :view_attempts
    end
  end
end
