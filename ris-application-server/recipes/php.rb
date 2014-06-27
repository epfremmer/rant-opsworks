#
# Cookbook Name:: ris-application-server
# Recipe:: php
#
# Copyright 2014, Rant Media Network
#
# All rights reserved - Do Not Redistribute
#

package 'php5' do
    action :install
end

package 'php5-fpm' do
    action :install
end

package 'php5-common' do
    action :install
end

package 'php5-curl' do
    action :install
end

package 'php5-dev' do
    action :install
end

package 'php5-gd' do
    action :install
end

package 'php5-imagick' do
    action :install
end

package 'php5-mcrypt' do
    action :install
end

package 'php5-memcache' do
    action :install
end

package 'php5-mysql' do
    action :install
end

package 'php5-pspell' do
    action :install
end

package 'php5-sqlite' do
    action :install
end

package 'php5-xmlrpc' do
    action :install
end

package 'php5-xsl' do
    action :install
end

# package 'php5-pear' do
#     action :install
# end

package 'libssh2-php' do
    action :install
end

package 'php5-cli' do
    action :install
end

directory '/var/run/php5-fpm' do
    owner 'root'
    group 'root'
    recursive true
    mode '0644'
end

service 'php5-fpm' do
    action [ :restart ]
end
