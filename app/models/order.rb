# Copyright (C) 2011 by Philippe Bourgau

class Order < ActiveRecord::Base

  NOT_PASSED = 0
  PASSING = 1
  SUCCEEDED = 2
  FAILED = 3

  def self.missing_cart_line_notice(cart_line, store)
    "Nous n'avons pas pu ajouter '#{cart_line.name}' à votre panier sur '#{store.name}' parce que cela n'y est plus disponible"
  end

  def self.invalid_store_login_notice(store)
    "Désolé, nous n'avons pas pu vous connecter à '#{store.name}'. Vérifiez vos identifiant et mot de passe."
  end

  belongs_to :cart
  belongs_to :store

  validates_presence_of :forwarded_cart_lines_count

  def initialize(attributes = {})
    defaults = { :status => Order::NOT_PASSED,
                 :warning_notices_text => "",
                 :error_notice => "",
                 :forwarded_cart_lines_count => 0}
    super(defaults.merge(attributes))
  end

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
      @store.with_session(login, password) do |session|
        @cart.forward_to(session, self)
      end
      self.status = Order::SUCCEEDED

    rescue InvalidStoreAccountError
      self.status = Order::FAILED
      self.error_notice = Order.invalid_store_login_notice(self.store)

    rescue
      self.status = Order::FAILED
      raise

    end
  end

  private

  WARNING_NOTICE_SEPARATOR = "\n"

end
