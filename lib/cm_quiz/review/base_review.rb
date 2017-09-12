require 'cm_quiz/review_helper'

module CmQuiz
  module Review
    class BaseReview
      include ReviewHelper

      def perform
        run
        build_test_result(test_case_title)
      rescue RSpec::Expectations::ExpectationNotMetError => e
        build_test_result(test_case_title, false, e.message)
      rescue => e
        build_test_result(test_case_title, false, e.message)
      end

      def run
        raise "Method `run` should be implemented on class #{self.class}"
      end

      def test_case_title
        "#{@verb} #{@path}"
      end
    end
  end
end