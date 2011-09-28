VERBOSE=nil
# I could not find radiant-settings-extension and radiant-page_preview-extension (maybe because they don't have a .gemspec)
# If ever we need their rake tasks, let's just include them by hand ? or fork them and create real gems
%w(radiant-tags-extension radiant-comments-extension radiant-mailer-extension).each do |gem_name|
  Dir["#{Gem.searcher.find(gem_name).full_gem_path}/lib/tasks/*.rake"].each do |ext|
    load ext
  end
end
