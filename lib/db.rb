# @file db.rb

require 'active_record'
require 'yaml'

root_path = File.expand_path('..', File.dirname(__FILE__))
db_config = YAML::load(File.open("#{root_path}/config/database.yml"))
ActiveRecord::Base.establish_connection(db_config)
