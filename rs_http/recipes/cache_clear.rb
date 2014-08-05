#
# Cookbook Name:: rs_http
# Recipe:: clear_cache
#
# Copyright 2014, Rant Media Network
#
# All rights reserved - Do Not Redistribute
#
# Clear all cached application assets - this should only be used
# after performing an application deployment on an existing instance
#
# encoding: UTF-8

Encoding.default_external = Encoding::UTF_8 if RUBY_VERSION > "1.9"

app_web_root = "#{node['rant']['nginx']['web_root']}/#{node['rant']['nginx']['vhost']}"

bash "app_cache_clear" do
    cwd "#{app_web_root}/current"
    code <<-EOH
        sudo app/console --env=staging redis:flushall
    EOH
end

service 'php5-fpm' do
    provider Chef::Provider::Service::Upstart
    supports :restart => true
    action :restart
end
