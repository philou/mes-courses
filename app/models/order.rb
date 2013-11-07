# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

class Order < ActiveRecord::Base
  include MesCourses::Notifications::ByMail

  NOT_PASSED = "not_passed"
  PASSING = "passing"
  SUCCEEDED = "succeeded"
  FAILED = "failed"

  def self.missing_cart_line_notice(cart_line_name, store_name)
    "Nous n'avons pas pu ajouter '#{cart_line_name}' à votre panier sur '#{store_name}' parce que cela n'y est plus disponible"
  end

  def self.invalid_store_login_notice(store_name)
    "Désolé, nous n'avons pas pu vous connecter à '#{store_name}'. Vérifiez vos identifiant et mot de passe."
  end

  attr_accessible :cart, :store, :status

  belongs_to :cart
  belongs_to :store

  validates_presence_of :forwarded_cart_lines_count

  after_initialize :assign_default_values

  def add_missing_cart_line(cart_line)
    self.warning_notices_text = self.warning_notices_text + Order.missing_cart_line_notice(cart_line.name, self.store.name) + Order::WARNING_NOTICE_SEPARATOR
  end

  def warning_notices
    warning_notices_text.split(Order::WARNING_NOTICE_SEPARATOR)
  end

  def notify_forwarded_cart_line
    self.forwarded_cart_lines_count= self.forwarded_cart_lines_count + 1
    self.save!
  end

  def pass(credentials)
    begin
      self.status = Order::PASSING
      store.with_session(credentials.email, credentials.password) do |session|
        cart.forward_to(session, self)
      end

      notify_order_passed(cart, credentials.email)

      self.status = Order::SUCCEEDED

    rescue MesCourses::Stores::Carts::InvalidAccountError
      self.status = Order::FAILED
      self.error_notice = Order.invalid_store_login_notice(self.store.name)

    rescue
      self.status = Order::FAILED
      raise

    ensure
      save!

    end
  end

  PASSED_RATIO_BEFORE = 0.15
  PASSED_RATIO_AFTER = 0.1
  PASSED_RATIO_DURING = 1.0 - PASSED_RATIO_BEFORE - PASSED_RATIO_AFTER

  def passed_ratio
    if created_at.nil?
      0.0
    elsif cart.lines.empty?
      1.0
    elsif forwarded_cart_lines_count == 0
      PASSED_RATIO_BEFORE * [1.0, (Time.now - created_at) / 60.0].min
    else
      PASSED_RATIO_BEFORE +
        PASSED_RATIO_DURING * forwarded_cart_lines_count.to_f / cart.lines.count
    end
  end

  delegate :name, :logout_url, :login_url, :login_parameters, :login_parameter, :password_parameter, to: :store, prefix: true

  private

  WARNING_NOTICE_SEPARATOR = "\n"

  def assign_default_values

    if new_record?
      self.status ||= Order::NOT_PASSED
      self.warning_notices_text ||= ""
      self.error_notice ||= ""
      self.forwarded_cart_lines_count ||= 0
    end
  end

end
