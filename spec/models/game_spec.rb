require 'spec_helper'

describe Game do
  let(:playable_game) { FactoryGirl.build(:playable_game) }
  let(:unplayable_game) { FactoryGirl.build(:unplayable_game) }

  subject { unplayable_game }

  it { should respond_to(:is_playable) }
  it { should be_valid }

  describe "value must be boolean" do
    before { unplayable_game.is_playable = {} }
    its(:is_playable) { should be_false }

    describe "when set to string 'true' " do
      before { unplayable_game.is_playable = 'true' }
      its(:is_playable) { should be_true }
      it { should be_valid }
    end

    describe "when set to boolean true" do
      before { unplayable_game.is_playable = true }
      its(:is_playable) { should be_true }
      it { should be_valid }
    end
  end
end
