require 'spec_helper'
require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
  
  config.before(:suite) do
   DatabaseCleaner.clean_with(:truncation)
   DatabaseCleaner.strategy = :truncation
  end

   config.around(:each) do |example|
     DatabaseCleaner.cleaning do
       example.run
     end
   end

   Shoulda::Matchers.configure do |config|
     config.integrate do |with|
       with.test_framework :rspec
       with.library :rails
     end
   end
end
