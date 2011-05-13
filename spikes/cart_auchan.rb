# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'rubygems'
require 'mechanize'

attempt = 1

#begin

  agent = Mechanize.new
  login_page = agent.get("http://www.auchandirect.fr/frontoffice")

  # 1° on se log
  login_form = Mechanize::Form.new(login_page.search('#formIdentification').first, login_page.mech, login_page)
  login_form.Username = "philippe.bourgau@free.fr_invalid"
  login_form.Password = "NoahRules78"
  res = login_form.submit()

  # 2° on vide le panier courant
  logged_page = agent.get("http://www.auchandirect.fr/frontoffice")
  scripts = logged_page.search('script')

  js = scripts.map {|script| script.inner_text }.join

puts js

  clientId = /oClient.id\s*=\s*([0-9]+)/.match(js)[1]
  panierId = /oPanier.id\s*=\s*([0-9]+)/.match(js)[1]


  agent.post("http://www.auchandirect.fr/frontoffice/index/ajax_liste",
             # INDISPENSABLES
             { 'Action' => 'panier_del',
               'ClientId' => clientId, # DOM: oClient.id
               'ListeId' => panierId}, # DOM: oPanier.id
             # DISPENSABLES
             #'ListeType' => 'P'},
             #'ListeNom' => 'AuchanDirect_Panier_785619',
             # 'ClientType' => '0',
             # "Articles" => '%5B%5D',
             # 'Eval' => '',
             # 'IdProdUpd' => '',
             {'Content-type' => 'application/x-www-form-urlencoded; charset=UTF-8'})

  #3° on ajoute tout ce qu'on veut acheter
  res = agent.post("http://www.auchandirect.fr/frontoffice/index/ajax_liste",
             { 'Action' => 'liste_ins',
               # indispensables
               'ClientId' => 785619,
               'ListeId' => 9365085,
               'ListeType' => 'P',
               'Articles' => '[{'+
               # indispensables
               '"maxcde":10,'+ # ça marche aussi avec 100 ...
               '"type":"p",'+
               '"id":66666666,'+ # on le trouve dans l'url du produit
               '"qte":1,'+
               '"prix_total":2.5'+ # on l'a pour chaque produit, quoi qu'on mette, il met le prix du magasin !

               # dispensables"
               #                             '"type_id":"p_59713",'+
               #                             '"statut":"d",'+
               #                             '"pondereux":0,'+
               #                             '"marque":"TSARINE",'+
               #                             '"libticket":"TSARINE Champagne Premium brut sous pochon fourré, 75 cl",'+
               #                             '"libweb":"Champagne cuvée Premium brut sous pochon fourré",'+
               #                             '"accroche":"Brut",'+
               #                             '"condlib":"75 cl",'+
               #                             '"prix":24.79,'+
               #                             '"unite":"33.05€ / l",'+
               #                             '"url":"http://www.auchandirect.fr/frontoffice/index/produit/famille/15169/rayon/15180/ssrayon/15819/article/59713",'+
               #                             '"upd":false,'+
               '}]'},
             #                            Ruby array of hash does not work
             #                            [{ 'maxcde' => 10, 'type' => 'p', 'id' => 59713, 'qte' => 1, 'prix_total' => 24.79 }]},

             # dispensables
             #             'ClientType' => '0',
             #             'Eval' => '',
             #             'IdProdUpd' => '59713',
             #             'ListeNom' => 'AuchanDirect_Panier_785619'},
             {'Content-type' => 'application/x-www-form-urlencoded; charset=UTF-8'})

  # 4° récupérer le prix du panier

  logged_page = agent.get("http://www.auchandirect.fr/frontoffice")
  scripts = logged_page.search('script')

  script = scripts.find {|script| !script.inner_text.empty? }
  js = script.inner_text

  articles = js.scan(/oPanier\s*\.\s*_insArticle\s*\(\s*"p_(\d+)"\s*,\s*(\d+)/)
  cart_amount = 0.0
  articles.each do |id, quantity|
    price = Regexp.compile('oCatalogue._insArticle\(.*,\s*'+id+'\s*,.*,\s*(\d+.\d\d)\s*,').match(js)[1]
    cart_amount += quantity.to_i * price.to_f
  end
  puts "cart amount is : #{cart_amount}"



  # 5° on se délog
  main_page = agent.get("http://www.auchandirect.fr/frontoffice")
  main_page.link_with(:text => "cliquez ici").click

  puts "Attempt ##{attempt} succeeded"

# rescue Exception => e
#   puts "Attempt  ##{attempt} failed because #{e}, retrying."
#   attempt += 1

#   retry unless 5 < attempt
# end


