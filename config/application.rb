require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BiblioCFPT
  class Application < Rails::Application
    #rescue_from ActiveRecord :: RecordNotFound, with:: render_404 rescue_from ActionController :: RoutingError, with:: render_404 rescue_from Exception, with:: render_500 
    #def render_404 render template:'errors / error_404', status: 404, layout:'application', content_type: 'text / html' 
    #end 
    #def render_500 render template:'errors / error_500', status: 500, layout:'application', content_type:'text / html' 
    #end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.exceptions_app = self.routes

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
