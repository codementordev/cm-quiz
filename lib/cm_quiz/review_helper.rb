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

    def build_test_result(klass, passed = true, message = nil)
      [klass.to_s.gsub(/^.*::/, ''), passed, message]
    end
  end
end
