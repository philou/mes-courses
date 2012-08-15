# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

module MesCourses::StoreCarts

  # Provides helper methods around the logout method idiom
  module WithLogoutMixin

    # executes the block before logging out.
    def with_logout
      begin
        yield self
      ensure
        logout
      end
    end
  end
end
