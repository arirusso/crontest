begin
	require 'rubygems'
rescue LoadError
end

require 'clap'

%w{crontest crontab_file crontab_helper}.each { |f| require File.expand_path("lib/#{f}", File.dirname(__FILE__)) }
