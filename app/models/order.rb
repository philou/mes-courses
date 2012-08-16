# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

class Order < ActiveRecord::Base

  NOT_PASSED = "not_passed"
  PASSING = "passing"
  SUCCEEDED = "succeeded"
  FAILED = "failed"

  def self.missing_cart_line_notice(cart_line, store)
    "Nous n'avons pas pu ajouter '#{cart_line.name}' à votre panier sur '#{store.name}' parce que cela n'y est plus disponible"
  end

  def self.invalid_store_login_notice(store)
    "Désolé, nous n'avons pas pu vous connecter à '#{store.name}'. Vérifiez vos identifiant et mot de passe."
  end

  belongs_to :cart
  belongs_to :store

  validates_presence_of :forwarded_cart_lines_count

  after_initialize :assign_default_values

  def add_missing_cart_line(cart_line)
    self.warning_notices_text = self.warning_notices_text + Order.missing_cart_line_notice(cart_line, self.store) + Order::WARNING_NOTICE_SEPARATOR
  end

  def warning_notices
    warning_notices_text.split(Order::WARNING_NOTICE_SEPARATOR)
  end

  def notify_forwarded_cart_line
    self.forwarded_cart_lines_count= self.forwarded_cart_lines_count + 1
  end

  def pass(login, password)
    begin
      self.status = Order::PASSING
      store.with_session(login, password) do |session|
        cart.forward_to(session, self)
      end
      self.status = Order::SUCCEEDED

    rescue MesCourses::StoreCart::InvalidAccountError
      self.status = Order::FAILED
      self.error_notice = Order.invalid_store_login_notice(self.store)

    rescue
      self.status = Order::FAILED
      raise

    ensure
      save!

    end
  end

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
