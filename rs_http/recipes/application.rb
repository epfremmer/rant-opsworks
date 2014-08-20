#
# Cookbook Name:: rs_http
# Recipe:: application
#
# Copyright 2014, Rant Media Network
#
# All rights reserved - Do Not Redistribute
#
# encoding: UTF-8

Encoding.default_external = Encoding::UTF_8 if RUBY_VERSION > "1.9"

app_web_root = "#{node['rant']['nginx']['web_root']}/#{node['rant']['nginx']['vhost']}"
app_env      = "#{node['rant']['application']['environment_name']}"

application node['rant']['application']['name'] do
    path "#{app_web_root}"
    owner node['rant']['deploy']['user']
    group node['rant']['deploy']['group']

    repository node['rant']['deploy']['repository']
    revision node['rant']['deploy']['branch']
end

log "Setting application environment vars..."

node['rant']['application']['environment_vars'].each do |parameter, value|
    log "#{parameter}: #{value}"
    ENV[parameter] = value
end

log "Installing dependencies..."

bash "install_application" do
    cwd "#{app_web_root}/current"
    code <<-EOH
        bin/composer install --no-dev --verbose --prefer-dist --optimize-autoloader --no-interaction -vvv
    EOH
end

directory "#{app_web_root}/current" do
    owner node['rant']['deploy']['user']
    group node['rant']['deploy']['group']
    recursive true
end

service 'php5-fpm' do
    provider Chef::Provider::Service::Upstart
    supports :restart => true
    action :restart
end
