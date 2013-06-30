# -*- coding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require 'rubygems'
require 'mechanize'
require 'net/http'
require 'json'

attempt = 1

#begin

agent = Mechanize.new

# 1° on se log
main = agent.get("http://www.auchandirect.fr")
puts main.uri


login_form_json = agent.post("http://www.auchandirect.fr/boutiques.paniervolant.customerinfos:showsigninpopup",
                            {'t:ac' => "Accueil", 't:cp' => 'gabarit/generated'},
                             {'X-Requested-With' => 'XMLHttpRequest',
#                               'Accept'=>'text/javascript, text/html, application/xml, text/xml, */*',
#                               'Accept-Charset'=>'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
#                               'Accept-Encoding'=>'gzip,deflate,sdch',
#                               'Accept-Language'=>'fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4',
#                               'Connection'=>'keep-alive',
#                               'Content-Length'=>'0',
#                               'Content-type'=>'application/x-www-form-urlencoded; charset=UTF-8',
#                              'Cookie'=>'c_cj_v2=_rn_lh%5BfyfcheZZZ222H%28%20.G%7D*0-.%20.H%21-ZZZKMPJSSRSRKORJZZZ%5Dfc%5De777_rn_lh%5BfyfcheZZZ222H-%20%21*%29/%20H%7B0%7D%23%7B%29%7E%24-%20%7D/H%21-ZZZKMPJSSSJLKJPLZZZ%5Dfc%5De777%5Ecl_%5Dny%5B%5D%5D_mmZZZZZZKMPKPJNRNPMRLZZZ%5Dfc%5De; JSESSIONID=C52BC02C08B7A33C2EB698A839286D05.485B4D5B58421C1F4F; tc_sdauid=1; __utma=135595873.1520176981.1327556606.1349843186.1363329164.28; __utmb=135595873.1.10.1363329164; __utmc=135595873; __utmz=135595873.1345660365.26.13.utmcsr=affilinet|utmccn=affilinet_clicparis|utmcmd=cpa',
#                               'Host'=>'www.auchandirect.fr',
#                               'Origin'=>'http://www.auchandirect.fr',
                               'Referer'=>main.uri,
#                               'User-Agent'=>'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.56 Safari/537.17',
#                               'X-Prototype-Version'=>'1.6.0.3'
                             })
puts "login form json : #{login_form_json.body}"
json = JSON.parse(login_form_json.body)
html = json["zones"]["secondPopupZone"]

doc = Nokogiri::HTML("<html><body>#{html}</body></html>")
formdata = doc.xpath("//input[@name='t:formdata']/@value").first.content
login = "mes.courses.fr.test@gmail.com"
password = "mescourses"
agent.post("http://www.auchandirect.fr/boutiques.blockzones.popuphandler.authenticatepopup.authenticateform",
           { 't:ac' => "Accueil",
             't:cp' => 'gabarit/generated',
             't:formdata' => formdata,
             'inputLogin' => login,
             'inputPwd' => password,
           },
           {'X-Requested-With' => 'XMLHttpRequest'}
           )

# just a check
login_response = agent.get("http://www.auchandirect.fr")
loggedin = !login_response.body.include?("Identifiez-vous")
puts "Login success : #{loggedin}"


# 2° récupérer le prix du panier
cart_page = agent.get("http://www.auchandirect.fr/monpanier")
cart_amount = cart_page.search("span.prix-total").first.content.gsub(/€$/,"").to_f
puts "Total cart amount : #{cart_amount}"

# 3° on ajoute tout ce qu'on veut acheter
3.times do
  res = agent.post("http://www.auchandirect.fr/boutiques.mozaique.thumbnailproduct.addproducttobasket/2005",
                   {'t:ac' => "Accueil", 't:cp' => 'gabarit/generated'},
                   {'X-Requested-With' => 'XMLHttpRequest'}
                   )
end

# just a check
cart_page = agent.get("http://www.auchandirect.fr/monpanier")
cart_amount = cart_page.search("span.prix-total").first.content.gsub(/€$/,"").to_f
puts "Add to cart success : #{cart_amount != 0}, total amount : #{cart_amount}"

# # 4° on vide le panier courant
# agent.post("http://www.auchandirect.fr/boutiques.blockzones.popuphandler.cleanbasketpopup.cleanbasket",
#            {'t:ac' => "Accueil", 't:cp' => 'gabarit/generated'},
#            {'X-Requested-With' => 'XMLHttpRequest'}
#            )

# # just a check
# cart_page = agent.get("http://www.auchandirect.fr/monpanier")
# cart_amount = cart_page.search("span.prix-total").first.content.gsub(/€$/,"").to_f
# puts "Empty cart success : #{cart_amount == 0}, total amount : #{cart_amount}"

# 5° on se délog
agent.post("http://www.auchandirect.fr/boutiques.paniervolant.customerinfos:totallogout",
           {'t:ac' => "Accueil", 't:cp' => 'gabarit/generated'},
           {'X-Requested-With' => 'XMLHttpRequest'}
           )

# just a check
logout_response = agent.get("http://www.auchandirect.fr")
loggedout = logout_response.body.include?("Identifiez-vous")
puts "Logout success : #{loggedout}"

# rescue Exception => e
#   puts "Attempt  ##{attempt} failed because #{e}, retrying."
#   attempt += 1

#   retry unless 5 < attempt
# end


