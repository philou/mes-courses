# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'rubygems'
require 'mechanize'

attempt = 1

begin

agent = Mechanize.new
login_page = agent.get("http://www.auchandirect.fr")

# 1° on se log
login_form = Mechanize::Form.new(login_page.search('#formIdentification').first, login_page.mech, login_page)
login_form.Username = "philippe.bourgau@free.fr"
login_form.Password = "NoahRules78"
login_form.submit()

# 2° on vide le panier courant
logged_page = agent.get("http://www.auchandirect.fr")
scripts = logged_page.search('script')

script = scripts.find {|script| !script.inner_text.empty? }
js = script.inner_text

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

# 3° on ajoute tout ce qu'on veut acheter

# TODO: try this, if it does not work, try to use a row of hashes instead of the string for Articles
#       when it works, try to remove dispensable arguments, and to find how to control quantity
agent.post("http://www.auchandirect.fr/frontoffice/index/ajax_liste",
           { 'Action' => 'liste_ins',
             # indispensables
             'ClientId' => '785619',
             'ListeId' => '9365085',
             'ListeType' => 'P',
             'Articles' => '[{'+
                             # indispensables
                             '"maxcde":10,'+ # ça marche aussi avec 100 ...
                             '"type":"p",'+
                             '"id":59713,'+ # on le trouve dans l'url du produit
                             '"qte":1,'+
                             '"prix_total":24.79'+ # on l'a pour chaque produit, quoi qu'on mette, il met le prix du magasin !

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


# 4° on se délog
main_page = agent.get("http://www.auchandirect.fr")
main_page.link_with(:text => "cliquez ici").click

puts "Attempt ##{attempt} succeeded"

rescue Exception
  puts "Attempt  ##{attempt} failed, retrying."
  attempt += 1
  retry
end


