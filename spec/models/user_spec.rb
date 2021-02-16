require 'rails_helper'

RSpec.describe User, type: :model do
  it do
    is_expected.to have_many(:sent_invites).
      class_name('Invite').
      with_foreign_key(:from_id).
      dependent(:nullify)
  end

  it do
    is_expected.to have_many(:received_invites).
      class_name('Invite').
      with_foreign_key(:to_id).
      dependent(:nullify)
  end

  it do
    is_expected.to have_many(:games_as_user_one).
      class_name('Game').
      with_foreign_key(:user_one_id).
      dependent(:nullify)
  end

  it do
    is_expected.to have_many(:games_as_user_two).
      class_name('Game').
      with_foreign_key(:user_two_id).
      dependent(:nullify)
  end

  describe  "#invites" do
    let(:user) { create :user }

    it "returns sent and received invites" do
      invite1 = create(:invite, from: user)
      invite2 = create(:invite, to: user)
      expect(user.invites).to include(invite1)
      expect(user.invites).to include(invite2)
    end

    it "does not include invites of other users" do
      invite = create(:invite)
      expect(user.invites).to_not include(invite)
    end

    context "with game" do
      let(:invite1) { create(:invite, :with_game, to: user) }
      let(:invite2) { create(:invite, :with_game, from: user) }

      it "returns invites with not canceled and not finished games" do
        expect(user.invites).to include(invite1)
        expect(user.invites).to include(invite2)
      end

      it "does not return invites with canceled or finished games" do
        invite1.game.update!(canceled: true)
        invite2.game.update!(finished: true)
        expect(user.invites).to_not include(invite1)
        expect(user.invites).to_not include(invite2)
      end
    end
  end
end
