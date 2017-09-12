$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rubygems'
require 'webmock/rspec'
require 'cm_quiz'
require 'pry'