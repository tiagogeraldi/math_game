require 'rails_helper'

RSpec.describe "Invites", type: :request do
  let(:peter) { create(:user, name: "Peter") }
  let(:john) { User.find_by(name: "John") }
  let(:invite) { create :invite, from: peter, to: john }

  before do
    sign_in "John"
  end

  describe "POST /invites" do
    it "creates an invite" do
      expect {
        post invites_path, params: {
          invite: {
            to_id: peter.id
          }
        }
      }.to change { Invite.count }.by(1)

      invite = Invite.last
      expect(invite.from.name).to eq "John"
      expect(invite.to).to eq peter
      expect(response).to have_http_status(302)

      assert_broadcasts("#{peter.id}:invites", 1)
      assert_broadcasts("#{john.id}:invites", 1)
    end

    it "does not duplicate a not answered invite" do
      john = User.find_by(name: "John")

      create :invite, from: john, to: peter

      expect {
        post invites_path, params: {
          invite: {
            to_id: peter.id
          }
        }
      }.to change { Invite.count }.by(0)

      expect(response).to have_http_status(302)
    end
  end

  describe "PUT /invites/id" do
    it "accepts an invite" do
      put invite_path(invite), as: :turbo_stream, params: {
        invite: {
          accepted: true
        }
      }
      expect(invite.reload.accepted).to eq true
      expect(response.body).to include "turbo-stream"

      assert_broadcasts("#{peter.id}:invites", 2)
      assert_broadcasts("#{john.id}:invites", 2)
    end

    it "invited user sets I am ready" do
      invite.update!(accepted: true)
      put invite_path(invite), as: :turbo_stream, params: {
        invite: {
          i_am_ready: true
        }
      }
      expect(invite.reload.to_ready).to eq true
      expect(response.body).to include "turbo-stream"
    end

    it "inviter user sets I am ready" do
      invite = create(:invite, from: john, to: peter, accepted: true)
      put invite_path(invite), as: :turbo_stream, params: {
        invite: {
          i_am_ready: true
        }
      }
      expect(invite.reload.from_ready).to eq true
      expect(response.body).to include "turbo-stream"
    end

    it "generates a game" do
      invite = create(:invite, from: john, to: peter, accepted: true, to_ready: true)

      expect do
        put invite_path(invite), as: :turbo_stream, params: {
          invite: {
            i_am_ready: true
          }
        }
      end.to change { Game.count }.by(1)
      expect(response).to have_http_status(302)
    end
  end

  describe "DELETE /invites/id" do
    it "destroys an invite" do
      delete invite_path(invite), as: :turbo_stream

      expect { invite.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(response.body).to include "turbo-stream"

      assert_broadcasts("#{peter.id}:invites", 2)
      assert_broadcasts("#{john.id}:invites", 2)
    end
  end
end
