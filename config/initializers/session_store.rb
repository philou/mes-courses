# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_MainSite_session',
  :secret      => 'ac93f99882d1dc6dd110fd92aec0a6465d0e133a152eb21cedb9f39796053afe8f216ba3f96f042cd52e8e520aefbf0c9e23d2fce3d2d02878907ba493624444'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
