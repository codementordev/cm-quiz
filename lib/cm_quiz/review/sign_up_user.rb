require 'securerandom'
require 'cm_quiz/review_helper'

module CmQuiz
  module Review
    class SignUpUser
      include ReviewHelper

      def initialize(project_api:)
        @project_api = project_api
      end

      def perform
        name = "codementor-test-#{SecureRandom.hex(5)}"
        email = "#{name}@codementor.io"
        password = "pAssw0rd!"
        res = send_sign_up_user_request(email: email, name: name, password: password)
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

      def send_sign_up_user_request(email:, name:, password:)
        options = {
          body: {
            email: email,
            name: name,
            password: password
          }
        }

        @project_api.request(:post, '/users', options)
      end
    end
  end
end
