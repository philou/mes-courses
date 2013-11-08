# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

module KnowsCart

  def buy_items(table)
    each_quantity_and_name_in(table) do |quantity, item_name|
      put_item_in_the_cart(quantity, item_name)
    end
  end

  def buy_dishes(table)
    each_quantity_and_name_in(table) do |quantity, name|
      put_dish_in_the_cart(quantity, name)
    end
  end


  def put_item_in_the_cart(quantity, item_name)
    item = Item.find_by_name(item_name)
    throw ArgumentError.new("Item '#{item_name}' could not be found") unless item

    quantity.times do
      visit item_category_path(item.item_categories.first)
      within(:xpath, "//div[@id='items-panel']//tr[td/text()='#{item.name}']") do
        click_button('Ajouter au panier')
      end
    end
  end

  def put_dish_in_the_cart(quantity, dish_name)
    quantity.times do
      visit dishes_path
      within(:xpath, "//table[@id='dish-panel']//tr[td/a/text()='#{dish_name}']") do
        click_button('Ajouter au panier')
      end
    end
  end

  def empty_the_cart
    visit_cart_page

    click_button('Vider le panier')
  end

  def ready_to_transfer_the_cart
    visit_cart_page
  end

  def transfer_the_cart(email = MesCourses::Stores::Carts::Api.valid_email, password = MesCourses::Stores::Carts::Api.valid_password)
    enter_store_account_identifiers(email, password)
    start_transfering_the_cart
    run_the_transfer_to_the_end
    refresh_page
    current_route_should_be(:order_logout_path, /\d+/)
    refresh_page
    current_route_should_be(:order_login_path, /\d+/)
  end

  def try_to_transfer_the_cart_with_wrong_identifiers(email = MesCourses::Stores::Carts::Api.invalid_email, password = MesCourses::Stores::Carts::Api.invalid_password)
    enter_store_account_identifiers(email, password)
    start_transfering_the_cart
    run_the_transfer_to_the_end
    refresh_page
    current_route_should_be(:cart_lines_path)
  end

  def enter_store_account_identifiers(email = MesCourses::Stores::Carts::Api.valid_email, password = MesCourses::Stores::Carts::Api.valid_password)
    visit_cart_page
    fill_in(MesCourses::Stores::Carts::DummyApi.login_parameter, :with => email)
    fill_in(MesCourses::Stores::Carts::DummyApi.password_parameter, :with => password)
  end

  def start_transfering_the_cart
    click_button("Transférer le panier")
  end

  def wait_while_no_items_are_transfered
    Timecop.travel(Time.now + 15)
  end

  def run_the_transfer_to_the_end
    Delayed::Worker.new().work_off()
  end

  def start_the_transfer_thread
    @finish_cart_transfer = ConditionEvent.new
    @logged_out = ConditionEvent.new

    cart_api.stub(:logout) do
      @logged_out.set
      @finish_cart_transfer.wait
    end

    @cart_transfer_thread = Thread.new do
      Delayed::Worker.new().work_off()
    end

    @logged_out.wait
  end

  def join_the_transfer_thread
    @finish_cart_transfer.set
    @cart_transfer_thread.join
  end

  def the_cart_should_contain_items(table)
    each_quantity_and_name_in(table) do |quantity, item_name|
      the_cart_should_contain_item(quantity, item_name)
    end
  end

  def the_cart_should_contain_item(quantity, item_name)
    item = Item.find_by_name(item_name)
    expect(item).not_to be_nil, "could not find an item with name '#{item_name}'"

    visit_cart_page
    expect(page).to contain_a(cart_line_with_long_name_and_quantity(item.long_name, quantity))
  end

  def the_cart_should_contain_dishes(table)
    visit_cart_page
    each_quantity_and_name_in(table) do |quantity, name|
      expect(page).to contain_a(dish_with_name(name))
    end
  end

  def the_cart_should_not_contain_any_item
    visit_cart_page
    expect(page).not_to contain_a(cart_line)
  end

  def the_cart_should_not_contain_any_dish
    visit_cart_page
    expect(page).not_to contain_a(dish_line)
  end

  def the_cart_should_amount_to(price)
    visit_cart_page
    expect(find(:xpath, "//tr[td/text()='Total']/td[contains(.,'€')]").text.to_f).to eq(price)
  end

  def there_should_be_a_buying_confirmation(name)
    expect(page).to contain_a(buying_confirmation_notice(name))
  end

  def the_transfer_should_be_ongoing(options)
    page_should_auto_refresh

    expect(page).to have_content("Votre panier est en cours de transfert vers '#{options[:to]}'")

    ratio_element = page.find_by_id('transfer-ratio')
    expect(ratio_element).not_to be_nil

    progress = ratio_element.text.to_f
    expect(progress).to be >= options[:min_progress]
    expect(progress).to be <= options[:max_progress]
  end

  def the_client_should_be_automaticaly_logged_out_from(store_name)
    cart_api = MesCourses::Stores::Carts::Api.for_url("http://#{store_name}")

    page_should_contain_an_iframe("remote-store-iframe", cart_api.logout_url)
  end

  def there_should_be_a_button_to_a_new_tab_to_log_into(store_name)
    cart_api = MesCourses::Stores::Carts::Api.for_url("http://#{store_name}")

    expect(page).to have_content("Votre panier a été transféré à '#{store_name}'")
    expect(page).to have_xpath("//form[@action='#{cart_api.login_url}'][@target='_blank']")
  end

  private

  def visit_cart_page
    visit path_to("the cart page")
  end

  def each_quantity_and_name_in(table)
    table.hashes_with_defaults('name', 'quantity' => 1).each do |hash|
      yield hash['quantity'].to_i, hash['name']
    end
  end

end
World(KnowsCart)
