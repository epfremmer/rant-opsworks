#
# Cookbook Name:: ris-application-server
# Recipe:: nginx
#
# Copyright 2014, Rant Media Network
#
# All rights reserved - Do Not Redistribute
#

package 'nginx-full' do
    action :install
end

service 'nginx' do
    action [ :enable, :start ]
end

cookbook_file '/etc/nginx/nginx.conf' do
    owner 'root'
    group 'root'
    source 'nginx.conf'
    mode '0644'
end

cookbook_file '/etc/nginx/conf.d/mail.conf' do
    owner 'root'
    group 'root'
    source 'mail.conf'
    mode '0644'
end

cookbook_file '/etc/nginx/security' do
    owner 'root'
    group 'root'
    source 'security'
    mode '0644'
end

cookbook_file '/etc/nginx/fastcgi_params' do
    owner 'root'
    group 'root'
    source 'fastcgi_params'
    mode '0644'
end

link '/etc/nginx/sites-enabled/default' do
    action :delete
    only_if 'test -L /etc/nginx/sites-enabled/default'
end

directory '/var/www' do
    owner 'www-data'
    owner 'www-data'
    mode '0644'
    action :create
end

service 'nginx' do
    action [ :restart ]
end
