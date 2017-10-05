$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../support', __FILE__)
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

require 'rubygems'
require 'webmock/rspec'
require 'cm_quiz'
require 'pry'

RSpec.configure do |config|
  config.include AssertTestCase
end
