module CmQuiz
  module Review
    class DeleteIdea < BaseReview
      def initialize(project_api:)
        @project_api = project_api
        @verb = :delete
        @path = '/ideas/:idea_id'
      end

      def run
        jwt, _ = Factory::User.new({
          project_api: @project_api
        }).create
        idea_payload = Factory::Idea.new({
          project_api: @project_api,
          jwt: jwt
        }).create
        idea_id = idea_payload['id']

        send_delete_idea_request(jwt: jwt, idea_id: idea_id)

        res = send_get_ideas_request(jwt: jwt)
        res_hash = JSON.parse(res.body)
        idea = res_hash.find { |item| item['id'] == idea_id }
        expect(idea).to be_nil
      end

      private

      def send_delete_idea_request(jwt:, idea_id:)
        @options = {
          headers: {
            'x-access-token' => jwt
          }
        }

        @path = "/ideas/#{idea_id}"
        @project_api.request(:delete, @path, @options)
      end

      def send_get_ideas_request(jwt:)
        options = {
          headers: {
            'x-access-token' => jwt
          }
        }

        @project_api.request(:get, "/ideas", options)
      end
    end
  end
end
