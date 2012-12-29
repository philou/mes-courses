#!/bin/sh

wget --recursive --level=inf --no-clobber --convert-links --no-clobber --quota=100000k --exclude-directories=/assets,/static,/apropos --wait=1 --user-agent=Mozilla --domains=auchandirect.fr,refonte.auchandirect.fr -e robots=off --adjust-extension 'www.refonte.auchandirect.fr'

