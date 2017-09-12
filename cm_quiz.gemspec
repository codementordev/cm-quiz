lib_dir = File.join(File.dirname(__FILE__),'lib')
$LOAD_PATH << lib_dir unless $LOAD_PATH.include?(lib_dir)
require 'cm_quiz/version'

Gem::Specification.new do |s|
  s.name        = 'cm_quiz'
  s.version =  CmQuiz::VERSION
  s.date        = '2017-09-12'
  s.summary     = "Review your codementor quiz"
  s.description = "Review your codementor quiz"
  s.authors     = ["ben"]
  s.email       = 'ben@codementor.ios'
  s.executables = ["cm-quiz"]
  s.files = `git ls-files`.split($/)
  s.homepage    =
  'https://github.com/codementordev/cm_quiz'
  s.license       = 'MIT'
  s.required_ruby_version = '>= 2.3'

  s.add_dependency('thor', ["~> 0.19.4"])
  s.add_dependency("rspec", ["~> 3.6"])
  s.add_dependency("httparty", ["~> 0.15.6"])
  s.add_development_dependency("webmock", ["~> 3.0"])
end
