require 'securerandom'

module CmQuiz
  module Factory
    class User
      def initialize(project_api:, name: nil, email: nil, password: nil)
        @project_api = project_api
        @name = name || "codementor-test-#{SecureRandom.hex(5)}"
        @email = email || "#{@name}@codementor.io"
        @password = password || "pAssw0rd!"
      end

      def create
        options = {
          body: {
            email: @email,
            name: @name,
            password: @password
          }
        }

        res = @project_api.request(:post, '/users', options)
        payload = JSON.parse(res.body)
        [payload['jwt'], payload['refresh_token']]
      rescue => e
        raise StandardError, "Create test user failed, reason: #{e.message}"
      end
    end
  end
end
