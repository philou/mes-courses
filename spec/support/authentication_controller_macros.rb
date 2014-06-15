# Copyright (C) 2011, 2012 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


module AuthenticationControllerMacros

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def ignore_user_authentication
      before :each do
        controller.stub(:user_signed_in?).and_return(false)
      end
    end
  end

  def stub_signed_in_user(attributes = {})
    controller.stub(:authenticate_user!)
    controller.stub(:user_signed_in?).and_return(true)
    controller.stub(:current_user).and_return(stub_model(User, attributes))
  end

end

