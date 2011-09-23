VERBOSE=nil
%w(radiant-tags-extension radiant-comments-extension radiant-mailer-extension).each do |gem_name|
  Dir["#{Gem.searcher.find(gem_name).full_gem_path}/lib/tasks/*.rake"].each do |ext|
    load ext
  end
end
