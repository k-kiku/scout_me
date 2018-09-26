require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Railtie.load

HOSTNAME = ENV['HOSTNAME']

module ScoutMe
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    
    #Railsを日本語化する為に
      config.i18n.default_locale = :ja 
    #タイムゾーンの設定
      config.time_zone = 'Tokyo'
      config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    #ActionMailerのviewに画像を追加する為に
      config.action_mailer.asset_host = 'https://scout2-korosuke.c9users.io'
  end
end


