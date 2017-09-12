require 'thor'
require 'cm_quiz'

module CmQuiz
  class CLI< Thor
    map '--version' => :version

    desc 'version', 'Prints the cm_quiz version'
    def version
      puts "#{File.basename($0)} #{VERSION}"
    end

    desc 'test', 'Test your api implement'
    option :endpoint, required: true, banner: "your-test-endpoint.com"
    def test
      endpoint = options[:endpoint]
      puts "Start test #{endpoint}"
      message = CmQuiz::ReviewQuiz.new('http://localhost:6000').perform
      puts message
    end
  end
end
