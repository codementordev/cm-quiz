require 'securerandom'

module CmQuiz
  module Factory
    class Idea
      def initialize(project_api:, jwt:, idea_params: {})
        @project_api = project_api
        @jwt = jwt
        @idea_params = idea_params
      end

      def create
        default_idea_params = {
          content: 'the-content',
          impact: 7,
          ease: 8,
          confidence: 9
        }

        options = {
          headers: {
            'x-access-token' => @jwt
          },
          body: default_idea_params.merge(@idea_params)
        }

        res = @project_api.request(:post, '/ideas', options)
        JSON.parse(res.body)
      rescue => e
        raise StandardError, "Create test idea failed, reason: #{e.message}"
      end
    end
  end
end
