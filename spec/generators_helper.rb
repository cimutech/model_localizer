require 'rubygems'
require "bundler/setup"

require 'rails'

ENV['ADAPTER'] ||= 'active_record'
if ENV['ADAPTER'] == 'active_record'
  require 'active_record/railtie'
end

module TestApp
  class Application < ::Rails::Application
    config.root = File.dirname(__FILE__)
  end
end

require 'ammeter/init'