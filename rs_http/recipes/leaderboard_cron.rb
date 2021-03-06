#
# Cookbook Name:: rs_http
# Recipe:: leaderboard_cron
#
# Copyright 2014, Edward Pfremmer. All rights Reserved.
#
# Proprietary license.
#
# This recipe should only be run on a single Cron Server instance. This is in
# order to ensure that we are not running cron scripts simultaneously across
# multiple instances
#
# encoding: UTF-8

app_web_root = "#{node['rant']['nginx']['web_root']}/#{node['rant']['nginx']['vhost']}"
log_file     = "#{node['rant']['nginx']['log_dir']}/#{node['rant']['nginx']['vhost']}.leaderboard_cron.log"
app_env      = "#{node['rant']['application']['environment_name']}"

cron "leaderboard_cron" do
  minute "0"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:comments:userleaderboard:build >> #{log_file} 2>&1"
  user "root"
end
