require 'rspec'

module CmQuiz
  module ReviewHelper
    def expect(target)
      RSpec::Expectations::ExpectationTarget.new(target)
    end

    def eq(obj)
      RSpec::Matchers::BuiltIn::Eq.new(obj)
    end

    def be
      RSpec::Matchers::BuiltIn::Be.new
    end

    def be_within(delta)
      RSpec::Matchers::BuiltIn::BeWithin.new(delta)
    end

    def build_test_result(test_case, passed = true, message = nil)
      [test_case, passed, message]
    end
  end
end
