# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

module MesCourses::Stores::Carts

  # Store API for AuchanDirect store
  class AuchanDirectApi < Api

    # main url of the store
    def self.url
      "http://www.auchandirect.fr"
    end

    # Logins to auchan direct store
    def initialize(login, password)
      @agent = Mechanize.new
      page = @agent.get(AuchanDirectApi.url)

      login_form = Mechanize::Form.new(page.search('#formIdentification').first,
                                       page.mech,
                                       page)
      login_form.Username = login
      login_form.Password = password
      login_form.submit()

      @client_id, @panier_id = extract_ids
      raise InvalidAccountError unless @client_id.to_i != 0

    end

    # logs out from the store
    def logout
      @agent.get(self.class.logout_url)
    end

    # url at which a client browser can logout
    def self.logout_url
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
    def set_item_quantity_in_cart(quantity, item_remote_id)
      @agent.post(url+"/frontoffice/index/ajax_liste",
                  { 'Action' => 'liste_ins', 'ClientId' => @client_id, 'ListeId' => @panier_id, 'ListeType' => 'P',
                    'Articles' => '[{"maxcde":10, "type":"p"'+
                    ',"id":' + item_remote_id.to_s +
                    ',"qte":' + quantity.to_s +
                    ',"prix_total" : 1.0' +
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
      return scripts.map {|script| script.inner_text }.join
    end

  end
end
