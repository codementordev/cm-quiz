module CmQuiz
  class ReviewQuiz
    def initialize(endpoint)
      @endpoint = endpoint
    end

    def perform
      test_results = perform_tests(@endpoint)
      build_message(test_results, @endpoint)
    end

    private

    def perform_tests(endpoint)
      project_api = ProjectAPI.new(endpoint)
      tests = []
      tests << Review::LoginUser.new(project_api: project_api).perform
      tests << Review::SignUpUser.new(project_api: project_api).perform
      tests << Review::GetUserInfo.new(project_api: project_api).perform
      tests << Review::CreateIdea.new(project_api: project_api).perform
      tests << Review::GetIdeas.new(project_api: project_api).perform
      tests << Review::UpdateIdea.new(project_api: project_api).perform
      tests << Review::DeleteIdea.new(project_api: project_api).perform
      tests
    end

    def build_message(test_results, endpoint)
      score, failed_results = arrange_results(test_results)
      example_messages = failed_results.map do |result|
        m = (result[0].to_s + ": " + result[2].to_s).gsub("\n", ' ')
        m = m.truncate(120) + '...' if m.size > 120
        m
      end
      text = ([
        "endpoint: #{endpoint}",
        "score: #{score}",
        "#{test_results.size} examples, #{failed_results.size} failures"
      ] + example_messages).join("\n")
      text
    end

    def arrange_results(test_results)
      total_result_size = test_results.size
      failed_results = test_results.select { |test_result| test_result[1] == false }
      failed_result_size = failed_results.size
      score = 100 * (total_result_size - failed_result_size)/ total_result_size.to_f

      [score.round(2), failed_results]
    end
  end
end
