SELENIUM_SERVER = '10.0.2.2'  
RAILS_APP_HOST = '127.0.0.1'  
CAPYBARA_DRIVER = 'selenium_remote_firefox'  
Capybara.javascript_driver = :selenium_remote_firefox

RSpec.configure do |config|  
  config.before :each do
    if selenium_remote?
      Capybara.app_host = "http://#{SELENIUM_APP_HOST}:3001"
    end
  end
  config.after :each do
    Capybara.reset_sessions!
    Capybara.use_default_driver
    Capybara.app_host = nil
  end
  def selenium_remote?
    !(Capybara.current_driver.to_s =~ /\Aselenium_remote/).nil?
  end
end

class CapybaraDriverRegistrar  
  def self.register_selenium_local_driver browser
    Capybara.register_driver "selenium_#{browser}".to_sym do |app|
      Capybara::Selenium::Driver.new app, browser: browser
    end
  end
  def self.register_selenium_remote_driver browser
    Capybara.register_driver "selenium_remote_#{browser}".to_sym do |app|
      Capybara::Selenium::Driver.new app, browser: :remote, url: "http://#{SELENIUM_SERVER}:4444/wd/hub", desired_capabilities: browser
    end
  end
end

CapybaraDriverRegistrar.register_selenium_remote_driver :firefox  