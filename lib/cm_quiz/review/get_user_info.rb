require 'securerandom'

module CmQuiz
  module Review
    class GetUserInfo < BaseReview
      def initialize(project_api:)
        @project_api = project_api
        @verb = :get
        @path = '/me'
      end

      def run
        name = "codementor-test-#{SecureRandom.hex(5)}"
        email = "#{name}@codementor.io"
        password = "pAssw0rd!"
        jwt, _refresh_token = Factory::User.new({
          project_api: @project_api,
          name: name,
          email: email,
          password: password
        }).create

        res = send_get_user_info_request(jwt: jwt)
        payload = JSON.parse(res.body)

        expect(payload['email']).to eq(email)
        expect(payload['name']).to eq(name)
      end

      private

      def send_get_user_info_request(jwt:)
        options = {
          headers: {
            'x-access-token' => jwt
          }
        }

        @project_api.request(@verb, @path, options)
      end
    end
  end
end
