# Copyright (C) 2011 by Philippe Bourgau

namespace :file_system do

  namespace :to_db do
    desc "Loads all layouts and snippets from the filesystem."
    task :layouts_and_snippets => ["file_system:to_db:layouts","file_system:to_db:snippets"]
  end

  namespace :to_files do
    desc "Saves all layouts and snippets to the filesystem."
    task :layouts_and_snippets => ["file_system:to_files:layouts","file_system:to_files:snippets"]
  end

end
