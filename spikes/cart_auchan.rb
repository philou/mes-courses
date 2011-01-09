# Copyright (C) 2010 by Philippe Bourgau

require 'rubygems'
require 'mechanize'

SHOPPING_LIST_NAME = "mes-courses.fr"

agent = Mechanize.new
login_page = agent.get("http://www.auchandirect.fr")

# 1° on se log
login_form = Mechanize::Form.new(login_page.search('#formIdentification').first, login_page.mech, login_page)
login_form.Username = "philippe.bourgau@free.fr"
login_form.Password = "NoahRules78"
login_form.submit().inspect

# 2° on vide le panier courant

# http://www.auchandirect.fr/frontoffice/index/ajax_liste?Action=panier_del&Articles=%5B%5D&ClientId=785619&ClientType=0&Eval=&IdProdUpd=&ListeId=9365085&ListeNom=AuchanDirect_Panier_785619&ListeType=P
empty_cart_page = agent.post("http://www.auchandirect.fr/frontoffice/index/ajax_liste",
                             # INDISPENSABLES
                             { "Action" => "panier_del",
                               'ClientId' => '785619', # DOM: oClient.id
                               'ListeId' => '9365085'}, # DOM: oPanier.id
                               # DISPENSABLES
                               #'ListeType' => 'P'},
                               #'ListeNom' => 'AuchanDirect_Panier_785619',
                               # 'ClientType' => '0',
                               # "Articles" => '%5B%5D',
                               # 'Eval' => '',
                               # 'IdProdUpd' => '',
                             {'Content-type' => 'application/x-www-form-urlencoded; charset=UTF-8'})

# Host: www.auchandirect.fr
# User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.9.2.13) Gecko/20101206 Ubuntu/10.10 (maverick) Firefox/3.6.13
# Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
# Accept-Language: fr,fr-fr;q=0.8,en-us;q=0.5,en;q=0.3
# Accept-Encoding: gzip,deflate
# Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7
# Keep-Alive: 115
# Connection: keep-alive
# Content-Type: application/x-www-form-urlencoded; charset=UTF-8
# Referer: http://www.auchandirect.fr/frontoffice/index/ssrayon/famille/19300/rayon/19307/ssrayon/19316/
# Content-Length: 143
# Cookie: AuchanDirect_Clientdatelivraisonprevue=datelivraisonprevu:::29%2F12%2F10; AuchanDirect_Client=CLT_TYPE:::0&&&CLT_LOGIN:::PHILIPPE.BOURGAU%40FREE.FR&&&CLT_NOM:::Bourgau&&&CLT_PRENOM:::Philippe&&&CLT_ID:::785619&&&CP_ID:::78380&&&CLT_TYPEIMG:::0&&&dateConnection:::30-12-2010+07%3A42&&&cpcheck:::1; AuchanDirect_Carroussel=position:::pos%3D-24%7Cflga%3Dinline%7Cflgm%3Dnone%7Cflda%3Dinline%7Cfldm%3Dnone&&&clignDroit:::0; __utma=135595873.1118853579.1279601563.1293608286.1293691039.14; __utmz=135595873.1279601563.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utmb=135595873.19.10.1293691039; PHPSESSID=epg6bgbho7pem241d43c0r4k42; __utmc=135595873
# Pragma: no-cache
# Cache-Control: no-cache

# http://www.auchandirect.fr/frontoffice/index/ajax_liste?Action=panier_del&Articles=%5B%5D&ClientId=785619&ClientType=0&Eval=&IdProdUpd=&ListeId=9365085&ListeNom=AuchanDirect_Panier_785619&ListeType=P

# 3° on ajoute tout ce qu'on veut acheter


# 4° on se délog
main_page = agent.get("http://www.auchandirect.fr")
main_page.link_with(:text => "cliquez ici").click




# Spike with mechanize + Ajax post
#   essayer agent.post(...)
#   voir si ça fonctionne mieux
#   essayer d'enlever des paramètres au post (ideal: Action=panier_del)

# spike with watir,
# spike amazon ec2
#   mesurer le coût par panier
#   mesurer la complexité d'infra
#   spiker




## OLD WAY, BAD WAY
# # détruit la liste mes-courses.fr si besoin
# lists_page = nil
# main_page.search("#bandeau_accueil a").each do |htmlA|
#   if htmlA.attribute("title").value == "Mes listes"
#     lists_page = Mechanize::Page::Link.new(htmlA, main_page.mech, main_page).click
#   end
# end

# lists_page.search("#tableauListes tbody tr").each do |h_shopping_list|

#   cell = h_shopping_list.css("td").first
#   if cell.to_s.include? SHOPPING_LIST_NAME

#     # list_page = Mechanize::Page::Link.new(cell.css("a").first, lists_page.mech, lists_page).click
#     # list_page.search("#detailsListes tbody tr").each do |h_item|

#     #   cells = h_item.css("td")
#     #   puts cells[5].css("a").first
#     #   Mechanize::Page::Link.new(cells[5].css("a").first, list_page.mech, list_page).click
#     # end
#   end
# end
# # il faut aller dans les détails de la liste, et supprimer tout ce qui est dedans, ça efface la liste -> utilise JS -> KO

# # On pourrait aussi envoyer un message construit pour effacer la liste
# # Sinon, il parait que watir permet d'utiliser le javascript -> ça doit être un browser complet sans fenêtre


# main_page = agent.get("http://www.auchandirect.fr")




# # ajoute 5 bouteilles de champagne dans mon panier
# # construit une liste mes-courses.fr à partir du panier
# # se delog
