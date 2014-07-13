#
# Cookbook Name:: ris-application-server
# Recipe:: php
#
# Copyright 2014, Rant Media Network
#
# All rights reserved - Do Not Redistribute
#
# encoding: UTF-8

Encoding.default_external = Encoding::UTF_8 if RUBY_VERSION > "1.9"

ruby_block 'Clear php-fpm pool configurations' do
    block do
        Dir.foreach(node['rant']['php']['pool_dir']) {|f| fn = File.join(node['rant']['php']['pool_dir'], f); File.delete(fn) if f != '.' && f != '..'}
    end
end

directory node['rant']['php']['socket_dir'] do
    mode '0755'
    action :create
end

template "#{node['rant']['php']['pool_dir']}/#{node['rant']['nginx']['vhost']}.conf" do
    source 'phpfpm.conf.erb'
    mode '0500'
    variables(
        :pool_name => node['rant']['nginx']['vhost'],
        :user => node['rant']['deploy']['user'],
        :group => node['rant']['deploy']['group'],
        :error_log_path => "#{node['rant']['php']['log_dir']}/#{node['rant']['nginx']['vhost']}.error.log",
        :socket_path => node['rant']['php']['socket_dir']
    )
end

service 'php5-fpm' do
    provider Chef::Provider::Service::Upstart
    supports :restart => true
    action :restart
end
