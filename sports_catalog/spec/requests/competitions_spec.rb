require 'rails_helper'

RSpec.describe "Competitions", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:competition) { create(:competition, user: other_user) }

  describe "GET /competitions" do
    it "redirects unauthenticated users to the login page" do
      get competitions_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "allows authenticated users to see the list" do
      sign_in user
      get competitions_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /competitions/:id" do
    it "prevents a user from deleting someone else's competition" do
      sign_in user

      delete competition_path(competition)

      expect(response).to redirect_to(competitions_path)
      expect(flash[:alert]).to eq("You don't have permission for this competition.")
    end
  end
end
