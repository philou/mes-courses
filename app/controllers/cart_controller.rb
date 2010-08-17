
# Controller for the shopping cart
class CartController < ApplicationController

  # Displays the full session's cart
  def show
    @cart = find_cart
  end

  # adds the item with params[:id] to the cart
  def add_to_cart
    @cart = find_cart
    item = Item.find(params[:id])
    @cart.add_item(item)

    redirect_to show_all_path(:controller => "items")
  end

  private

  def find_cart
    session[:cart] ||= Cart.new
  end
end
