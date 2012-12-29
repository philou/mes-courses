# -*- coding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'rubygems'
require 'mechanize'
require 'net/http'
require 'json'

attempt = 1

#begin

agent = Mechanize.new

# 1° on se log
agent.get("http://www.auchandirect.fr")
login_form_json = agent.post("http://www.refonte.auchandirect.fr/boutiques.paniervolant.customerinfos:showsigninpopup",
                            {'t:ac' => "Accueil", 't:cp' => 'gabarit/generated'},
                            {'X-Requested-With' => 'XMLHttpRequest'})
json = JSON.parse(login_form_json.body)
html = json["zones"]["secondPopupZone"]

doc = Nokogiri::HTML("<html><body>#{html}</body></html>")
formdata = doc.xpath("//input[@name='t:formdata']/@value").first.content
login = "mes.courses.fr.test@gmail.com"
password = "mescourses"
agent.post("http://www.refonte.auchandirect.fr/boutiques.blockzones.popuphandler.authenticatepopup.authenticateform",
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
cart_page = agent.get("http://www.refonte.auchandirect.fr/monpanier")
cart_amount = cart_page.search("span.prix-total").first.content.gsub(/€$/,"").to_f
puts "Total cart amount : #{cart_amount}"

# 3° on ajoute tout ce qu'on veut acheter
3.times do
  res = agent.post("http://www.refonte.auchandirect.fr/boutiques.mozaique.thumbnailproduct.addproducttobasket/2005",
                   {'t:ac' => "Accueil", 't:cp' => 'gabarit/generated'},
                   {'X-Requested-With' => 'XMLHttpRequest'}
                   )
end

# just a check
cart_page = agent.get("http://www.refonte.auchandirect.fr/monpanier")
cart_amount = cart_page.search("span.prix-total").first.content.gsub(/€$/,"").to_f
puts "Add to cart success : #{cart_amount != 0}, total amount : #{cart_amount}"

# # 4° on vide le panier courant
# agent.post("http://www.refonte.auchandirect.fr/boutiques.blockzones.popuphandler.cleanbasketpopup.cleanbasket",
#            {'t:ac' => "Accueil", 't:cp' => 'gabarit/generated'},
#            {'X-Requested-With' => 'XMLHttpRequest'}
#            )

# # just a check
# cart_page = agent.get("http://www.refonte.auchandirect.fr/monpanier")
# cart_amount = cart_page.search("span.prix-total").first.content.gsub(/€$/,"").to_f
# puts "Empty cart success : #{cart_amount == 0}, total amount : #{cart_amount}"

# 5° on se délog
agent.post("http://www.refonte.auchandirect.fr/boutiques.paniervolant.customerinfos:totallogout",
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


