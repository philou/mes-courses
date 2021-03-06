# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau
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


module MesCourses
  module Stores
    module Imports

      # Objects able to dig into an online store and notify their "store" about
      # the items and item categories that they found for sale.
      class Base

        # Imports the items sold from the online store to our db
        def import(walker, store)
          @walker_stack = []
          @store = store
          if @store.last_import_finished?
            log :info, "Starting new import from #{walker.uri}"
            @store.starting_import
          else
            log :info, "Resuming import from #{walker.uri}"
          end

          unless_already_visited(walker) do
            dig(walker)
          end

          @store.finishing_import
          log :info, "Finished import"
        end

        private

        attr_reader :store

        def walk_category(walker, parent)
          unless_already_visited(walker) do
            item_category = store.register_item_category(walker.attributes.merge(:parent => parent))

            dig(walker, item_category)
          end
        end

        def walk_item(walker, item_category)
          unless_already_visited(walker) do
            params = walker.attributes
            params[:item_categories] = [item_category]

            log :debug, "Found item #{params.inspect}"
            store.register_item(params)
          end
        end

        # digs into sub categories and items of walker
        def dig(walker, item_category = nil)
          follow(walker.items, :walk_item, item_category)
          follow(walker.categories, :walk_category, item_category)
        end
        def follow(walkers, message, parent = nil)
          walkers.each do |walker|
            self.send(message, walker, parent)
          end
        end

        def unless_already_visited(walker)
          if store.already_visited_url?(walker.uri.to_s)
            log :debug, "Skipping #{walker.uri}"
          else
            with_rescue "Following link #{walker.uri}" do
              yield
              store.register_visited_url(walker.uri.to_s)
            end
          end
        end

        def with_rescue(summary)
          begin
            log :debug, summary
            @walker_stack.push(summary)
            yield

          rescue Storexplore::BrowsingError, ActiveRecord::RecordInvalid, Mechanize::ResponseCodeError => e
            # this should mean a page was not in an importable format
            # continue, this will eventually delete the faulty items
            log :warn, format_exception_message(summary, e)
          rescue Exception => e
            log :error, runtime_exception_message(summary, e)
            raise
          ensure
            @walker_stack.pop
          end
        end

        def log(level, message)
          Rails.logger.send(level, message)
        end

        def format_exception_message(summary, exception)
          (["Failed: \"#{summary}\""] + walker_stack + ["because #{exception}"]).join("\n\t")
        end
        def runtime_exception_message(summary, exception)
          (["Failed: \"#{summary}\"", "because #{exception}"]).join("\n\t")
        end

        def walker_stack
          @walker_stack.reverse.map { |task| "while \"#{task}\"" }
        end

      end
    end
  end
end
