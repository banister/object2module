require 'rbconfig'

direc = File.dirname(__FILE__)
dlext = Config::CONFIG['DLEXT']
begin
    if RUBY_VERSION && RUBY_VERSION =~ /1.9/
        require "#{direc}/cobject2module.19.#{dlext}"
    else
        require "#{direc}/cobject2module.18.#{dlext}"
    end
rescue LoadError => e
    require "#{direc}/cobject2module.#{dlext}"
end
