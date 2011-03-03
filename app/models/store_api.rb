# Copyright (C) 2011 by Philippe Bourgau

require 'mechanize'

# Objects providing an api like access to third party online stores
class StoreAPI

  STORE_URL = "http://www.auchandirect.fr"

  # Logs in the store account of a user and returns a StoreAPI instance
  def self.login(login, password)
    agent = Mechanize.new
    page = agent.get(STORE_URL)

    login_form = Mechanize::Form.new(page.search('#formIdentification').first,
                                     page.mech,
                                     page)
    login_form.Username = login
    login_form.Password = password
    login_form.submit()

    StoreAPI.new(agent)
  end

  def logout
    page = @agent.get(STORE_URL)
    page.link_with(:text => "cliquez ici").click
  end

  # empties the cart of the current user
  def empty_the_cart
    @agent.post(STORE_URL+"/frontoffice/index/ajax_liste",
                {'Action' => 'panier_del', 'ClientId' => @client_id, 'ListeId' => @panier_id},
                {'Content-type' => 'application/x-www-form-urlencoded; charset=UTF-8'})
  end

  # adds items to the cart of the current user
  def set_item_quantity_in_cart(quantity, item)
    @agent.post(STORE_URL+"/frontoffice/index/ajax_liste",
                { 'Action' => 'liste_ins', 'ClientId' => @client_id, 'ListeId' => @panier_id, 'ListeType' => 'P',
                  'Articles' => '[{"maxcde":10, "type":"p"'+
                                 ',"id":' + item.remote_id.to_s +
                                 ',"qte":' + quantity.to_s +
                                 ',"prix_total":' + (quantity*item.price).to_s +
                                 '}]'},
                {'Content-type' => 'application/x-www-form-urlencoded; charset=UTF-8'})

  end

  private

  def initialize(agent)
    @agent = agent
    @client_id, @panier_id = extract_ids
  end

  def extract_ids
    page = @agent.get(STORE_URL)
    scripts = page.search('script')

    script = scripts.find {|script| !script.inner_text.empty? }
    js = script.inner_text

    client_id = /oClient.id\s*=\s*([0-9]+)/.match(js)[1]
    panier_id = /oPanier.id\s*=\s*([0-9]+)/.match(js)[1]

    [client_id, panier_id]
  end

end
