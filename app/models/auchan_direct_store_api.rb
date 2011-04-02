# Copyright (C) 2011 by Philippe Bourgau

require 'store_api'

# Store API for AuchanDirect store
class AuchanDirectStoreAPI < StoreAPI

  # main url of the store
  def self.url
    "http://www.auchandirect.fr"
  end

  # Logins to auchan direct store
  def initialize(login, password)
    @agent = Mechanize.new
    page = @agent.get(AuchanDirectStoreAPI.url)

    login_form = Mechanize::Form.new(page.search('#formIdentification').first,
                                     page.mech,
                                     page)
    login_form.Username = login
    login_form.Password = password
    login_form.submit()

    @client_id, @panier_id = extract_ids
    raise InvalidStoreAccountError unless @client_id.to_i != 0

  end

  # logs out from the store
  def logout
    @agent.get(logout_url)
  end

  # url at which a client browser can logout
  def logout_url
    url+"/frontoffice/index/deconnexion/"
  end

  # total value of the remote cart
  def value_of_the_cart
    js = get_embedded_js

    result = 0.0
    js.scan(/oPanier\s*\.\s*_insArticle\s*\(\s*"p_(\d+)"\s*,\s*(\d+)/).each do |id, quantity|
      price = Regexp.compile('oCatalogue._insArticle\(.*,\s*'+id+'\s*,.*,\s*(\d+.\d\d)\s*,').match(js)[1]
      result += quantity.to_i * price.to_f
    end
    result
  end

  # empties the cart of the current user
  def empty_the_cart
    @agent.post(url+"/frontoffice/index/ajax_liste",
                {'Action' => 'panier_del', 'ClientId' => @client_id, 'ListeId' => @panier_id},
                {'Content-type' => 'application/x-www-form-urlencoded; charset=UTF-8'})
  end

  # adds items to the cart of the current user
  def set_item_quantity_in_cart(quantity, item)
    @agent.post(url+"/frontoffice/index/ajax_liste",
                { 'Action' => 'liste_ins', 'ClientId' => @client_id, 'ListeId' => @panier_id, 'ListeType' => 'P',
                  'Articles' => '[{"maxcde":10, "type":"p"'+
                                 ',"id":' + item.remote_id.to_s +
                                 ',"qte":' + quantity.to_s +
                                 ',"prix_total":' + (quantity*item.price).to_s +
                                 '}]'},
                {'Content-type' => 'application/x-www-form-urlencoded; charset=UTF-8'})

  end

  private
  def extract_ids
    js = get_embedded_js

    client_id = /oClient.id\s*=\s*([0-9]+)/.match(js)[1]
    panier_id = /oPanier.id\s*=\s*([0-9]+)/.match(js)[1]

    [client_id, panier_id]
  end

  def get_embedded_js
    page = @agent.get(url)
    scripts = page.search('script')

    script = scripts.find {|script| !script.inner_text.empty? }
    return script.inner_text
  end


end
