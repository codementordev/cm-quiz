require 'securerandom'
require 'cm_quiz/review_helper'

module CmQuiz
  module Review
    class LoginUser
      include ReviewHelper

      def initialize(project_api:)
        @project_api = project_api
      end

      def perform
        name = "codementor-test-#{SecureRandom.hex(5)}"
        email = "#{name}@codementor.io"
        password = "pAssw0rd!"
        Factory::User.new({
          project_api: @project_api,
          name: name,
          email: email,
          password: password
        }).create

        res = send_login_user_request(email: email, password: password)
        payload = JSON.parse(res.body)

        expect(payload['jwt'].class).to eq(String), '`jwt` should be string'
        expect(payload['refresh_token'].class).to eq(String), '`refresh_token` should be string'
        build_test_result(self.class)
      rescue RSpec::Expectations::ExpectationNotMetError => e
        build_test_result(self.class, false, e.message)
      rescue => e
        build_test_result(self.class, false, e.message)
      end

      private

      def send_login_user_request(email:, password:)
        options = {
          body: {
            email: email,
            password: password
          }
        }

        @project_api.request(:post, '/access-tokens', options)
      end
    end
  end
end
