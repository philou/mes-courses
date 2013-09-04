# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

class OrderMailer < ActionMailer::Base
  default from: "order@mes-courses.fr"

  MEMO_SUBJECT = "Les recettes de votre commande"

  def memo(user, dishes)
    @dishes = dishes
    mail to: user, subject: MEMO_SUBJECT
  end
end
