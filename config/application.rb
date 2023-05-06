require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OshigadgeApp
  class Application < Rails::Application
    # AWSのリージョンの設定。Herokuのデプロイエラーの解消のため
    require 'aws-sdk-core'
    Aws.config.update({
      region: ENV['AWS_REGION']
    })

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.active_storage.variant_processor = :vips

    # 日本時間に設定
    config.time_zone = 'Tokyo'
    config.to_prepare do
      Time::DATE_FORMATS[:default] = "%Y年%m月%d日 %H:%M"
      Date::DATE_FORMATS[:default] = "%Y年%m月%d日"
    end
  end
end
