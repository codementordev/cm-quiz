require 'securerandom'
require 'cm_quiz/review_helper'

module CmQuiz
  module Review
    class GetUserInfo
      include ReviewHelper

      def initialize(project_api:)
        @project_api = project_api
      end

      def perform
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
        build_test_result(self.class)
      rescue RSpec::Expectations::ExpectationNotMetError => e
        build_test_result(self.class, false, e.message)
      rescue => e
        build_test_result(self.class, false, e.message)
      end

      private

      def send_get_user_info_request(jwt:)
        options = {
          headers: {
            'x-access-token' => jwt
          }
        }

        @project_api.request(:get, '/me', options)
      end
    end
  end
end
