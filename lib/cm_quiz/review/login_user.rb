require 'securerandom'

module CmQuiz
  module Review
    class LoginUser < BaseReview
      def initialize(project_api:)
        @project_api = project_api
        @verb = :post
        @path = '/access-tokens'
      end

      def run
        name = "codementor-test-#{SecureRandom.hex(5)}"
        email = "#{name}@codementor.io"
        password = "pAssw0rd!"
        Factory::User.new({
          project_api: @project_api,
          name: name,
          email: email,
          password: password
        }).create

        @options = build_options(email: email, password: password)
        res = send_request(@options)
        payload = JSON.parse(res.body)

        expect(payload['jwt'].class).to eq(String), '`jwt` should be string'
        expect(payload['refresh_token'].class).to eq(String), '`refresh_token` should be string'
      rescue => e
        build_test_result(self.class, false, e.message)
      end

      private

      def build_options(email:, password:)
        options = {
          body: {
            email: email,
            password: password
          }
        }
      end

      def send_request(options)
        @project_api.request(@verb, @path, options)
      end
    end
  end
end
