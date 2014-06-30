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
    mode '0755'
    recursive true
end

cookbook_file '/var/www/login.rantmn.org/web/info.php' do
    owner 'root'
    group 'root'
    source 'info.php'
    mode '0755'
end

cookbook_file '/etc/nginx/sites-available/login.rantmn.org' do
    owner 'root'
    group 'root'
    source 'nginx.staging-vhost'
    mode '0644'
end

link '/etc/nginx/sites-enabled/login.rantmn.org' do
    to '/etc/nginx/sites-available/login.rantmn.org'
    notifies :restart, 'service[nginx]'
end

cookbook_file '/etc/php5/fpm/pool.d/login.rantmn.org.conf' do
    owner 'root'
    group 'root'
    source 'login.rantmn.org.conf'
    mode '0644'
end

execute 'restartPhpFpm' do
    command 'sudo service php5-fpm restart'
    action :nothing
end
