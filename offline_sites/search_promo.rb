require "uri"

file_names = `find ./www.auchandirect.fr/ -name *.html | xargs -0 grep -l "prix-promo"`.split("\n")

puts file_names.size
puts file_names[0]
# file_names.map do |file_name|
#   URI.unescape(file_name.gsub(/.*www.auchandirect.fr\//,""))
# end

# puts file_names.find_all {|file_name| 6 <= file_name.count('/') }
