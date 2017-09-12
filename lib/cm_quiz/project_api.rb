require 'httparty'

module CmQuiz
  class ProjectAPI
    REQUEST_TIMEOUT = 5

    class PerformFailed < StandardError
      attr_reader :response

      def initialize(message, response)
        @response = response
        super(message)
      end
    end

    def initialize(endpoint)
      @endpoint = endpoint
    end

    def request(verb, path, options = {})
      url = @endpoint + path

      query = options[:query]
      body = options[:body].to_json
      headers = { 'Content-Type' => 'application/json' }.merge(options[:headers] || {})

      http_options = {
        query: query,
        body: body,
        headers: headers,
        timeout: REQUEST_TIMEOUT
      }
      res = HTTParty.send(verb, url, http_options)

      raise PerformFailed.new("[#{res.code}]: #{res.body}", res) unless res.success?

      res
    end
  end
end
