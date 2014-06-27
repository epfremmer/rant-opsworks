#
# Cookbook Name:: ris-application-server
# Recipe:: nginx
#
# Copyright 2014, Rant Media Network
#
# All rights reserved - Do Not Redistribute
#


directory '/var/www/login.rantmn.org/web' do
    owner 'www-data'
    group 'www-data'
    mode '0644'
    recursive true
end

cookbook_file '/var/www/login.rantmn.org/web/info.php' do
    owner 'root'
    group 'root'
    source 'info.php'
    mode '0644'
end

cookbook_file '/etc/nginx/sites-available/login.rantmn.org' do
    owner 'root'
    group 'root'
    source 'login.rantmn.org'
    mode '0644'
end

link '/etc/nginx/sites-enabled/login.rantmn.org' do
    to '/etc/nginx/sites-available/login.rantmn.org'
end

cookbook_file '/etc/php5/fpm/pool.d/login.rantmn.org.conf' do
    owner 'root'
    group 'root'
    source 'login.rantmn.org.conf'
    mode '0644'
end

service 'nginx' do
    action [ :restart ]
end

service 'php5-fpm' do
    action [ :restart ]
end
