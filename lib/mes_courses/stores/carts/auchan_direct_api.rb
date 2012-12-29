# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require_relative 'api'
require 'json'

module MesCourses
  module Stores
    module Carts

      # Store API for AuchanDirect store
      class AuchanDirectApi < Api

        # main url of the store
        def self.url
          "http://www.auchandirect.fr"
        end

        # Logins to auchan direct store
        def initialize(login, password)
          @agent = Mechanize.new
          do_login(login, password)
          raise InvalidAccountError unless loged_in?
        end

        # logs out from the store
        def logout
          get(self.class.logout_path)
        end

        # url at which a client browser can logout
        def self.logout_url
          impl_url + logout_path
        end

        # total value of the remote cart
        def cart_value
          cart_page = get("/monpanier")
          cart_page.search("span.prix-total").first.content.gsub(/€$/,"").to_f
        end

        # empties the cart of the current user
        def empty_the_cart
          post("/boutiques.blockzones.popuphandler.cleanbasketpopup.cleanbasket")
        end

        # adds items to the cart of the current user
        def add_to_cart(quantity, item_remote_id)
          quantity.times do
            post("/boutiques.mozaique.thumbnailproduct.addproducttobasket/#{item_remote_id}")
          end
        end

        private

        def do_login(login,password)
          @agent.get(AuchanDirectApi.url)

          login_form_json = post("/boutiques.paniervolant.customerinfos:showsigninpopup")

          html_body = JSON.parse(login_form_json.body)["zones"]["secondPopupZone"]
          doc = Nokogiri::HTML("<html><body>#{html_body}</body></html>")
          formdata = doc.xpath("//input[@name='t:formdata']/@value").first.content

          post("/boutiques.blockzones.popuphandler.authenticatepopup.authenticateform",
               't:formdata' => formdata,'inputLogin' => login,'inputPwd' => password)
        end

        def loged_in?
          main_page = get("/Accueil")
          !main_page.body.include?("Identifiez-vous")
        end

        def get(path)
          @agent.get(impl_url + path)
        end

        def post(path, parameters = {})
          @agent.post(impl_url + path, self.class.post_parameters.merge(parameters), fast_header)
        end

        def fast_header
          {'X-Requested-With' => 'XMLHttpRequest'}
        end

        def self.logout_path
          parametrized_path("/boutiques.paniervolant.customerinfos:totallogout", post_parameters)
        end

        def self.parametrized_path(path, parameters)
          string_parameters = parameters.map do |key,value|
            "#{key}=#{value}"
          end
          "#{path}?#{string_parameters.join('&')}"
        end

        def self.impl_url
          "http://www.refonte.auchandirect.fr"
        end

        def self.post_parameters
          {'t:ac' => "Accueil", 't:cp' => 'gabarit/generated'}
        end

        def method_missing(method_sym, *arguments, &block)
          if delegate_to_class?(method_sym)
            self.class.send(method_sym, *arguments, &block)
          else
            super
          end
        end

        def respond_to?(method_sym)
          super or delegate_to_class?(method_sym)
        end
        def delegate_to_class?(method_sym)
          self.class.respond_to?(method_sym) and
            ['path','url'].any? { |suffix| method_sym.to_s.end_with?("_#{suffix}") }
        end
      end
    end
  end
end
