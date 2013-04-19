require 'spec_helper'

describe Level do
  before do
    @level = FactoryGirl.build(:level_1)
    @level_2 = FactoryGirl.build(:level_2)
  end
  subject { @level }

  it { should respond_to(:question) }
  it { should respond_to(:answer) }
  it { should respond_to(:next_id) }
  it { should respond_to(:prev_id) }
  it { should respond_to(:hint) }
  it { should respond_to(:alt) }
  it { should respond_to(:title) }
  it { should respond_to(:extra_content) }
  it { should respond_to(:attempts) }
  it { should respond_to(:images) }

  describe "when filled with valid information" do
    it { should be_valid }
    its(:save) { should be_true }
  end

  describe "when answer is blank" do
    before { @level.answer = '' }
    it { should_not be_valid }
    its(:save) { should be_false }
    it { should have(1).errors_on(:answer) }
  end

  describe "when answer is more than 70 characters long" do
    before { @level.answer = "a" * 71 }
    it { should_not be_valid }
  end
  
  describe "should sterlize answer on save" do
    before { @level.answer = "ZOMG-30!!:)" }
    context "when answer is filled as 'ZOMG-30!!:)'" do
      before { @level.save }
      it { should be_valid }
      its(:answer) { should eq "zomg30" }
    end
  end

  describe "when asked to show attempts" do
    before do
      @level.save
      FactoryGirl.create_list(:attempt, 10, :level => @level, :user_id => 1)
    end
    it "should list 10 attempts" do
      @level.attempts.length.should eq 10
    end
  end
end
