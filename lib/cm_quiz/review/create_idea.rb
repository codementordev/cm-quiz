require 'cm_quiz/review_helper'

module CmQuiz
  module Review
    class CreateIdea
      include ReviewHelper

      def initialize(project_api:)
        @project_api = project_api
      end

      def perform
        jwt, _ = Factory::User.new({
          project_api: @project_api
        }).create

        res = send_create_idea_request({
          jwt: jwt,
          content: 'test-content',
          impact: 7,
          ease: 8,
          confidence: 9
        })
        payload = JSON.parse(res.body)

        expect(payload['impact']).to eq(7)
        expect(payload['ease']).to eq(8)
        expect(payload['confidence']).to eq(9)
        expect(payload['average_score']).to eq(8.0)

        build_test_result(self.class)
      rescue RSpec::Expectations::ExpectationNotMetError => e
        build_test_result(self.class, false, e.message)
      rescue => e
        build_test_result(self.class, false, e.message)
      end

      private

      def send_create_idea_request(jwt:, content:, impact:, ease:, confidence:)
        options = {
          headers: {
            'x-access-token' => jwt
          },
          body: {
            content: content,
            impact: impact,
            ease: ease,
            confidence: confidence
          }
        }

        @project_api.request(:post, '/ideas', options)
      end
    end
  end
end
