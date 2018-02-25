require 'date'

module CmQuiz
  module Review
    class GetIdeas < BaseReview

      def initialize(project_api:)
        @project_api = project_api
        @verb = :get
        @path = '/ideas'
      end

      def run
        jwt, _ = Factory::User.new({
          project_api: @project_api
        }).create
        idea_payload = Factory::Idea.new({
          project_api: @project_api,
          jwt: jwt,
          idea_params: {
            confidence: 10
          }
        }).create

        res = send_get_ideas_request(jwt: jwt)
        res_hash = JSON.parse(res.body)
        item = res_hash.first unless res_hash.empty?

        raise StandardError, "idea not found" unless item

        expect(item['content']).to eq(idea_payload['content'])
        expect(item['impact']).to eq(idea_payload['impact'])
        expect(item['ease']).to eq(idea_payload['ease'])
        expect(item['confidence']).to eq(idea_payload['confidence'])
        average_score = (idea_payload['impact'] + idea_payload['ease'] + idea_payload['confidence'])/ 3.0
        expect(item['average_score'].round(1)).to eq(average_score.round(1))
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
