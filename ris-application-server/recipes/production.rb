#
# Cookbook Name:: ris-application-server
# Recipe:: nginx
#
# Copyright 2014, Rant Media Network
#
# All rights reserved - Do Not Redistribute
#


directory '/var/www/login.rantmn.com/web' do
    owner 'www-data'
    group 'www-data'
    mode '0644'
    recursive true
end

cookbook_file '/var/www/login.rantmn.com/web/info.php' do
    owner 'root'
    group 'root'
    source 'info.php'
    mode '0644'
end

cookbook_file '/etc/nginx/sites-available/login.rantmn.com' do
    owner 'root'
    group 'root'
    source 'nginx.production-vhost'
    mode '0644'
end

link '/etc/nginx/sites-enabled/login.rantmn.com' do
    to '/etc/nginx/sites-available/login.rantmn.com'
    notifies :restart, 'service[nginx]'
end

cookbook_file '/etc/php5/fpm/pool.d/login.rantmn.com.conf' do
    owner 'root'
    group 'root'
    source 'login.rantmn.com.conf'
    mode '0644'
    notifies :restart, 'service[php-fpm]'
end
