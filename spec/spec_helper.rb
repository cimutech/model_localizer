require 'rubygems'
require "bundler/setup"

require 'model_localizer'
require 'rails'


ENV['ADAPTER'] ||= 'active_record'

load File.dirname(__FILE__) + "/support/adapters/#{ENV['ADAPTER']}.rb"

