APP_BASE = File.dirname(File.expand_path(__FILE__))
 
namespace :db do
  task :ar_init do
    # Load the database config
    require 'active_record'

    database_yml = YAML::load(File.open(APP_BASE + "/db/config.yml"))
    ActiveRecord::Base.establish_connection(database_yml)
  end

  namespace :schema do
    desc "Load a ar_schema.rb file into the database"
    task :load => :ar_init do
      file = ENV['SCHEMA'] || APP_BASE + "/db/schema.rb"
      load(file)
    end
  end
end
