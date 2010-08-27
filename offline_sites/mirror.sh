#!/bin/sh

wget --recursive --level=inf --no-clobber --convert-links --no-clobber --quota=100000k --exclude-directories=/frontoffice/css,/frontoffice/img,/frontoffice/js,/frontoffice/static,/frontoffice/index/astuces,/frontoffice/index/contact,/frontoffice/index/identification_rapide,/frontoffice/index/inscription_rapide,/frontoffice/index/listes_ajout,/frontoffice/index/lotvirt,/frontoffice/index/mdpperdu,/frontoffice/index/services --wait=1 --user-agent=Mozilla --domains=auchandirect.fr -e robots=off --adjust-extension 'www.auchandirect.fr'

