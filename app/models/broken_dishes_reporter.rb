# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

# class responsible to alert of dishes broken by deleted items during import
class BrokenDishesReporter < MonitoringMailer

  def email(items)
    @items = items
    setup_mail("There are broken dishes")
  end

end
