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

        expect(update_deleted_record(jwt, idea_id)).to eq("Invalid Idea id")
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

      def send_update_idea_request(jwt:, idea_id:, content: nil, impact: nil,
        ease: nil, confidence: nil)

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
        @path = "/ideas/#{idea_id}"

        @project_api.request(:put, @path, @options)
      end

      def update_deleted_record(jwt, idea_id)
        begin
          send_update_idea_request({
            jwt: jwt,
            idea_id: idea_id,
            content: 'test-updated-content',
            impact: 6,
            ease: 7,
            confidence: 8
          })
        rescue
          "Invalid Idea id"
        end
      end
    end
  end
end
