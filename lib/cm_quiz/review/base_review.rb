require 'cm_quiz/review_helper'

module CmQuiz
  module Review
    class BaseReview
      attr_reader :verb, :path, :options
      include ReviewHelper

      def perform
        run
        build_test_result(test_request)
      rescue RSpec::Expectations::ExpectationNotMetError => e
        build_test_result(test_request, false, e.message)
      rescue => e
        build_test_result(test_request, false, e.message)
      end

      def run
        raise "Method `run` should be implemented on class #{self.class}"
      end

      def build_test_result(test_case, passed = true, message = nil)
        [test_case, passed, message]
      end

      def test_request
        {
          verb: @verb,
          path: @path,
          options: @options
        }
      end
    end
  end
end