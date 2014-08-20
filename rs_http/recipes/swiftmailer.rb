#
# Cookbook Name:: rs_http
# Recipe:: swiftmailer
#
# Copyright 2014, Edward Pfremmer. All rights Reserved.
#
# Proprietary license.
#
# This recipe should run on all auth servers.
# Used to send spooled emails form the swiftmailer spool.
#
# encoding: UTF-8

app_web_root = "#{node['rant']['nginx']['web_root']}/#{node['rant']['nginx']['vhost']}"
log_file     = "#{node['rant']['nginx']['log_dir']}/#{node['rant']['nginx']['vhost']}.cron.log"
app_env      = "#{node['rant']['application']['environment_name']}"

package "sendmail" do
    action :install
end

cron "swiftmailer_spool_cron" do
  minute "*"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} swiftmailer:spool:send >> #{log_file} 2>&1"
  user "root"
end
