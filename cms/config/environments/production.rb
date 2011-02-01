# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger        = SyslogLogger.new


# Full error reports are disabled and caching is on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors if you bad email addresses should just be ignored
# config.action_mailer.raise_delivery_errors = false

# Cache your content for a longer time, the default is 5.minutes
# config.after_initialize do
#   SiteController.cache_timeout = 12.hours
# end

# Use mollom against spam
config.after_initialize do
  Radiant::Config['comments.mollom_publickey'] = 'e03fa9b3589ec6f18040b90c50bcf1d8'
  Radiant::Config['comments.mollom_privatekey'] = '451a5de0abc7414d8b81eec5915e7e8e'
end
