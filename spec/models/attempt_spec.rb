require 'spec_helper'

describe Attempt do
  before do
    @level_1 = FactoryGirl.create(:level_1)
    @level_2 = FactoryGirl.create(:level_2)
    @user_1  = FactoryGirl.create(:user)
    @user_2  = FactoryGirl.create(:second_user)
    @attempt = Attempt.new(:attempt => 'foo', :user_id => @user_1, :level_id => @level_1)
  end

  describe "should contain string value" do
    before { @attempt.attempt = 'foo' }
    subject { @attempt }
    it "passed with 'attempt' foo" do
      should be_valid
      expect(@attempt).to be_valid
    end

    describe "should get saved properly" do
      its(:save) { should be_true }
      context "should then have proper id(primary key)" do
        before { @attempt.save }
        its(:id) { should_not be_nil }
        its(:id) { should be_integer }
        its(:id) { should eq 1 }


        it "should be properly grouped by level" do
          expect(Attempt.group_by_level.map { |x| {:level_id => x.level_id, :total => x.total_attempts} }).to match_array [{:level_id => 1, :total => 1}]
        end
      end
    end
  end

  describe "should not be blank" do
    before { @attempt.attempt = '' }
    subject { @attempt }
    it { should_not be_valid }
    its(:save) { should be_false }
    context "and when tried to save" do
      before { @attempt.save }
      it { should have(1).errors_on(:attempt) }
      it "should give adequate error message" do
        expect(@attempt.errors.full_messages).to eq ["A guess can't be blank"]
      end
    end
  end

  describe "should have unique guess per user per level" do
    before do
      @attempt.save
    end

    context "when duplicate guess in that level created by user" do
      before { @attempt_2 = Attempt.new(:attempt => 'foo', :user_id => @user_1, :level_id => @level_1) }
      subject { @attempt_2 }
      it "should not be valid" do
        expect(@attempt_2).to_not be_valid
      end
      it { should have(1).errors_on(:attempt) }
      # it "should give message 'A guess should only be used once'" do
      #   expect(@attempt_2.errors.full_messages).to eq ["A guess should only be used once"]
      # end
      its(:save) { should_not be_true }
    end

    context "when different guess is made in that level by same user" do
      before { @attempt_2 = Attempt.new(:attempt => 'bar', :user_id => @user_1, :level_id => @level_1) }
      subject { @attempt_2 }
      it { should be_valid }
      it "should have no error" do
        expect(@attempt_2).to have(0).errors_on(:attempt)
      end
      its(:save) { should be_true }
    end
  end

  describe "when same guess is made by other user in same level" do
    before do
      @attempt.save
      @attempt_2 = Attempt.new(:attempt => 'foo', :level_id => @level_1, :user_id => @user_2)
      @attempt_2.user = @user_2
    end
    subject { @attempt_2 }
    it { should be_valid }
    its(:save) { should be_true }
    it { should have(0).errors_on(:attempt) }

    context "but if accompanied by same guess in that level again" do
      before do
        @attempt_2.save
        @attempt_3 = Attempt.new(:attempt => 'foo', :level_id => @level_1, :user_id => @user_2)
        @attempt_3.user = @user_2
      end
      subject { @attempt_3 }
      it { should_not be_valid }
      its(:save) { should be_false }
      it { should have(1).errors_on(:attempt) }
    end
  end
end
