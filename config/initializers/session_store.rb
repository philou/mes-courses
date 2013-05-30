# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2012, 2013 by Philippe Bourgau

# Be sure to restart your server when you modify this file.

# MesCourses::Application.config.session_store :cookie_store, key: '_mes_courses_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
MesCourses::Application.config.session_store :active_record_store
