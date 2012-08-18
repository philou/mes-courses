# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

def autoloading_file
  caller.map {|f| f.split(':').first }.find {|x| x != __FILE__ }
end

def autoload_relative(name, relative_path)
  autoload name, File.join(File.dirname(autoloading_file), relative_path)
end

def autoload_relative_ex(name, relative_path)
  autoload name, File.join(File.dirname(autoloading_file), File.basename(autoloading_file, ".*"), relative_path)
end
