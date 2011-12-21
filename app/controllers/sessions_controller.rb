# Copyright (C) 2011 by Philippe Bourgau


# This class is copied from devise-1.0.11/app/controllers/sessions_controller.rb
# I did not find any other way to override this controller
# TODO once migrated to Rails3, subclass it and tweak devise_for routing options

class SessionsController < ApplicationController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  include Devise::Controllers::InternalHelpers

  # GET /resource/sign_in
  def new
    unless flash[:notice].present?
      Devise::FLASH_MESSAGES.each do |message|
        set_now_flash_message :alert, message if params.try(:[], message) == "true"
      end
    end

    build_resource
    render_with_scope :new
  end

  # POST /resource/sign_in
  def create
    if resource = authenticate(resource_name)
      set_flash_message :notice, :signed_in
      sign_in_and_redirect(resource_name, resource, true)
    elsif [:custom, :redirect].include?(warden.result)
      throw :warden, :scope => resource_name
    else
      set_now_flash_message :alert, (warden.message || :invalid)
      clean_up_passwords(build_resource)
      render_with_scope :new
    end
  end

  # GET /resource/sign_out
  def destroy
    set_flash_message :notice, :signed_out if signed_in?(resource_name)
    sign_out_and_redirect(resource_name)
  end

  protected

  def clean_up_passwords(object)
    object.clean_up_passwords if object.respond_to?(:clean_up_passwords)
  end
end

class SessionsController
  include PathBarHelper

  ssl_required :create
  before_filter :assign_path_bar

  private
  def assign_path_bar
    self.path_bar= [path_bar_session_root]
  end
end
