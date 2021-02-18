require 'rails_helper'

RSpec.describe "Welcomes", type: :request do
  describe "GET /welcomes" do
    it "user is signed in" do
      sign_in "tester"
      get welcomes_path

      expect(response).to have_http_status(200)
    end

    it "redirects to sign up page" do
      get welcomes_path

      expect(response).to have_http_status(302)
    end
  end
end
