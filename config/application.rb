require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
require 'neo4j/railtie'
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ClingenKnowledge
  class Application < Rails::Application
    
    config.generators do |g|
      g.orm             :neo4j
    end
    config.assets.paths << Rails.root.join("app", "assets", "fonts")

    config.action_dispatch.rack_cache = true


    # Configure where the embedded neo4j database should exist
    # Notice embedded db is only available for JRuby
    # config.neo4j.session_type = :embedded  # default :http
    # config.neo4j.session_path = File.expand_path('neo4j-db', Rails.root)
    # config.neo4j.session.url = ENV['NEO4J_SERVER_PATH'] || 'bolt://localhost'
    # config.neo4j.session_type = :bolt
    # config.neo4j.session.url = 'bolt://tndeb:7687'
    # config.neo4j.session_username = ENV['NEO4J_USER'] || 'neo4j'
    # config.neo4j.session_password = ENV['NEO4J_PASS'] || 'clingen'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end


