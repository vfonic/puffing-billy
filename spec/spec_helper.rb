Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

require 'pry'
require 'billy/capybara/rspec'
require 'billy/watir/rspec'
require 'rack'
require 'logger'

browser = Billy.browser :phantomjs
Capybara.app = Rack::Directory.new(File.expand_path('../../examples', __FILE__))
Capybara.javascript_driver = :poltergeist_billy

Billy.configure do |config|
  config.logger = Logger.new(File.expand_path('../../log/test.log', __FILE__))
end

RSpec.configure do |config|
  include Billy::TestServer
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'

  config.before :all do
    start_test_servers
    @browser = browser
  end

  config.before :each do
    proxy.reset_cache
  end

  config.after :each do
    Billy.config.reset
  end

  config.after :suite do
    browser.close
  end
end
