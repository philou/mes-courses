# Copyright (C) 2011 by Philippe Bourgau

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
