# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

module KnowsCart

  def put_in_the_cart(quantity, item_name)
    # maybe it would be to better find out how not to use side effects of functions
    item = Item.find_by_name(item_name)
    throw ArgumentError.new("Item '#{item_name}' could not be found") unless item

    # this won't work if I have many items with the same item category
    quantity.times do
      visit item_category_path(item.item_categories.first)
      click_button("Ajouter au panier")
    end
  end

  def enter_valid_store_account_identifiers
    visit path_to("the cart page")
    fill_in("store[login]", :with => MesCourses::Stores::Carts::Api.valid_login)
    fill_in("store[password]", :with => MesCourses::Stores::Carts::Api.valid_password)
  end

  def enter_invalid_store_account_identifiers
    visit path_to("the cart page")
    fill_in("store[login]", :with => MesCourses::Stores::Carts::Api.invalid_login)
    fill_in("store[password]", :with => MesCourses::Stores::Carts::Api.invalid_password)
  end

  def start_transfering_the_cart
    click_button("Transférer le panier")
  end

  def run_the_transfer_to_the_end
    Delayed::Worker.new().work_off()
    visit current_path
  end

  def start_the_transfer_thread
    @finish_cart_transfer = false
    @finish_cart_transfer.extend(MonitorMixin)
    finish_asked = @finish_cart_transfer.new_cond
    cart_api.stub(:logout) do
      finish_asked.wait_while { !@finish_cart_transfer }
    end

    @cart_transfer_thread = Thread.new do
      Delayed::Worker.new().work_off()
    end
  end

  def join_the_transfer_thread
    @finish_cart_transfer = true
    @cart_transfer_thread.join
    visit current_path
  end

  def the_cart_should_contain(item_name)
    visit path_to("the cart page")
    page.should have_content(item_name)
  end

  def the_transfer_should_be_ongoing(options)
    page.should have_content("Votre panier est en cours de transfert vers '#{options[:to]}'")
    match = /Votre panier est en cours de transfert [^<]*([0-9]+)%/.match(page.body)
    progress = match[1].to_f
    progress.should be_between(options[:min_progress], options[:max_progress])

    page_should_auto_refresh
  end

  def the_client_should_be_automaticaly_logged_out_from(store_name)
    page_should_contain_an_iframe("remote-store-iframe", "http://#{store_name}/logout")
  end

  def there_should_be_a_button_to_log_into(store_name)
    page.should have_content("Votre panier a été transféré à '#{store_name}'")
    page_should_have_a_link("Aller vous connecter sur #{store_name} pour payer", "http://#{store_name}/sponsored")
  end

end
World(KnowsCart)
