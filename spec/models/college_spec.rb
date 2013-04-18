require 'spec_helper'

describe College do
  before do
    @college = College.new(name: "Indraprastha University")
  end
  subject { @college }

  it { should respond_to(:name) }
  it { should be_valid }
  describe "when name is not present" do
    before { @college.name = "" }
    it { should_not be_valid }
    it { should have(1).error_on :name }
  end

  describe "when name is already taken" do
    before do
      @college_dup = @college.dup
      @college_dup.save
    end
    it { should_not be_valid }
  end

  describe "when case insensitive name is already present" do
    before do
      @college.save
      @college_dup = College.new(:name => @college.name.upcase)
      @college_dup.save
    end
    it { @college_dup.should_not be_valid }
    it { @college_dup.should have(1).error_on(:name) }
  end
end
