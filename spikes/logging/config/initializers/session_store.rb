# Copyright (C) 2014 by Philippe Bourgau


# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_logging_session',
  :secret      => 'e93951ea9073c4533db5a61357af86dbc356a68bc459dd0600ab74a56073a1b33dde666521259b2758d08c9470d908cfcf9d32fe8b341aefe575efe939149b61'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
