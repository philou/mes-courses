# -*- encoding: utf-8 -*-
# Copyright (C) 2011 by Philippe Bourgau

# class responsible to alert of dishes broken by deleted items during import
class BrokenDishesReporter < MonitoringMailer

  def email items
    setup_mail("There are broken dishes", :items => items)
  end

end
