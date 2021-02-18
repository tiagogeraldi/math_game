require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users/new" do
    it "renders sign up form" do
      get new_user_path
      expect(response).to have_http_status(200)
      expect(response.body).to include "Sign in"
    end
  end

  describe "POST /users" do
    it "signs in" do
      post users_path, params: { user: { name: name } }
      expect(response).to have_http_status(302)
    end
  end

  describe "DELETE /users/id" do
    it "destroys a user" do
      user = create(:user)
      delete user_path(user)

      expect(response).to have_http_status(302)
      expect { user.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
