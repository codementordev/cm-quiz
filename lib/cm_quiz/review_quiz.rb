require 'json'

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
        verb = result[0][:verb].upcase
        path = result[0][:path]
        options = result[0][:options]
        passed = result[1]
        messages = ["===#{verb} #{@endpoint}#{path}==="]
        messages << ""
        messages << "HTTP method:"
        messages << verb
        messages << ""
        messages << "Url:"
        messages << "#{@endpoint}#{path}"
        messages << ""
        if !options.nil?
          messages << "Request options:"
          messages << ""
          messages << JSON.pretty_generate(options)
        end
        messages << ""
        messages << "Error message:"
        messages << ""
        error_message = result[2].to_s
        error_message = error_message.truncate(500) + '...' if error_message.size > 500
        messages << error_message + "\n"

        messages.join("\n")
      end
      text = ([
        "endpoint: #{endpoint}",
        "score: #{score}",
        "#{test_results.size} examples, #{failed_results.size} failures",
        ""
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
