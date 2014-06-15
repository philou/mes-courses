# Copyright (C) 2012 by Philippe Bourgau
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


require_dependency Blogit::Engine.root.join('app', 'controllers', 'blogit', 'posts_controller').to_s

module Blogit
  class PostsController
    before_filter :assign_body_id, :compute_tag_frequencies
    layout 'blog'

    def assign_body_id
      self.body_id= BLOG_BODY_ID
    end

    def compute_tag_frequencies
      @tags = Post.tag_counts
    end
  end
end
