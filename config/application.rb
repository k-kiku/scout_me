require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
if ['development', 'test'].include? ENV['RAILS_ENV']
 Dotenv::Railtie.load
end

HOSTNAME = ENV['HOSTNAME']

module ScoutMe
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    
    #Railsを日本語化する為に
      config.i18n.default_locale = :ja 
      config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
  end
end


