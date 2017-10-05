module CmQuiz
  module Review
    class CreateIdea < BaseReview
      def initialize(project_api:)
        @project_api = project_api
        @verb = :post
        @path = '/ideas'
      end

      def run
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

        expect(payload['impact']).to eq(7), "expect impact equal 7, but got #{payload['impact']}"
        expect(payload['ease']).to eq(8), "expect ease equal 8, but got #{payload['ease']}"
        expect(payload['confidence']).to eq(9), "expect confidence equal 9, but got #{payload['confidence']}"
        expect(payload['average_score']).to eq(8.0), "expect average_score equal 8, but got #{payload['average_score']}"
      end

      private

      def send_create_idea_request(jwt:, content:, impact:, ease:, confidence:)
        @options = {
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

        @project_api.request(@verb, @path, @options)
      end
    end
  end
end
