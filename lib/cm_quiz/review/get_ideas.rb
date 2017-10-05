require 'date'

module CmQuiz
  module Review
    class GetIdeas < BaseReview
      VALID_TIME_DIFF = 60 * 5

      def initialize(project_api:)
        @project_api = project_api
        @verb = :get
        @path = '/ideas'
        @now = Time.now
      end

      def run
        jwt, _ = Factory::User.new({
          project_api: @project_api
        }).create
        idea_payloads = 3.times.map do |i|
          Factory::Idea.new({
            project_api: @project_api,
            jwt: jwt,
            idea_params: {
              confidence: (3 + i) % 10 + 1
            }
          }).create
        end

        res = send_get_ideas_request(jwt: jwt)
        res_hash = JSON.parse(res.body)

        idea_payloads.each do |idea_payload|
          item = res_hash.find { |item| item['id'] == idea_payload['id'] }
          raise StandardError, "idea not found" unless item

          expect(item['content']).to eq(idea_payload['content'])
          expect(item['impact']).to eq(idea_payload['impact'])
          expect(item['ease']).to eq(idea_payload['ease'])
          expect(item['confidence']).to eq(idea_payload['confidence'])
          average_score = (idea_payload['impact'] + idea_payload['ease'] + idea_payload['confidence'])/ 3.0
          expect(item['average_score']).to be_within(0.1).of(average_score)
          diff = Time.now - Time.new(item['created_at'])
          expect(diff).to be <= VALID_TIME_DIFF
        end
      end

      private

      def send_get_ideas_request(jwt:, page: 1)
        @options = {
          headers: {
            'x-access-token' => jwt
          },
          query: {
            page: page
          }
        }

        @project_api.request(@verb, @path, @options)
      end
    end
  end
end
