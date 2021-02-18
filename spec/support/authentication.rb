module Helpers
  module Authentication
    def sign_in(name)
      post users_path, params: { user: { name: name } }
    end
  end
end
