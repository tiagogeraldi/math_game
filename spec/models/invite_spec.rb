require 'rails_helper'

RSpec.describe Invite, type: :model do
  it { is_expected.to belong_to(:from).class_name('User') }
  it { is_expected.to belong_to(:to).class_name('User') }
  it { is_expected.to have_one(:game).dependent(:nullify) }

  describe '#ready?' do
    it 'defaults false' do
      expect(subject.ready?).to be_falsey
    end

    it 'returns true if from_ready and to_ready are present' do
      subject.from_ready = true
      subject.to_ready = true
      expect(subject.ready?).to eq true
    end

    it 'returns false if from_ready is nil' do
      subject.to_ready = true
      expect(subject.ready?).to be_falsey
    end

    it 'returns false if to_ready is nil' do
      subject.from_ready = true
      expect(subject.ready?).to be_falsey
    end
  end

  describe '#am_i_ready?' do
    let(:user1) { build(:user) }
    let(:user2) { build(:user) }

    it 'from user is ready' do
      subject.from_ready = true
      subject.from = user1
      expect(subject.am_i_ready?(user1)).to eq true
      expect(subject.am_i_ready?(user2)).to be_falsey
    end

    it 'to user is ready' do
      subject.to_ready = true
      subject.to = user2
      expect(subject.am_i_ready?(user1)).to be_falsey
      expect(subject.am_i_ready?(user2)).to eq true
    end
  end
end
