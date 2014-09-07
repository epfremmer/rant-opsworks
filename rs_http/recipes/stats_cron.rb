#
# Cookbook Name:: rs_http
# Recipe:: stats_cron
#
# Copyright 2014, Edward Pfremmer. All rights Reserved.
#
# Proprietary license.
#
# Refresh various Stats Inc caches
#
# encoding: UTF-8

app_web_root    = "#{node['rant']['nginx']['web_root']}/#{node['rant']['nginx']['vhost']}"
log_file_prefix = "#{node['rant']['nginx']['log_dir']}/#{node['rant']['nginx']['vhost']}"
app_env         = "#{node['rant']['application']['environment_name']}"

# Refresh current data continuously starting at 8 am, the script will shut down automatically after 3am
# 0 12 * * * php app/console rant:stats:cbb:refresh:current >/dev/null 2>&1
# 0 12 * * * php app/console rant:stats:cfb:refresh:current >/dev/null 2>&1
# 0 12 * * * php app/console rant:stats:mlb:refresh:current >/dev/null 2>&1
# 0 12 * * * php app/console rant:stats:nba:refresh:current >/dev/null 2>&1
# 0 12 * * * php app/console rant:stats:nfl:refresh:current >/dev/null 2>&1
# 0 12 * * * php app/console rant:stats:nhl:refresh:current >/dev/null 2>&1

cron "cbb_refresh_current" do
  minute "0"
  hour "12"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:cbb:refresh:current >> #{log_file_prefix}.cbb_refresh_current_cron.log 2>&1"
  user "root"
end
cron "cfb_refresh_current" do
  minute "0"
  hour "12"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:cfb:refresh:current >> #{log_file_prefix}.cfb_refresh_current_cron.log 2>&1"
  user "root"
end
cron "mlb_refresh_current" do
  minute "0"
  hour "12"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:mlb:refresh:current >> #{log_file_prefix}.mlb_refresh_current_cron.log 2>&1"
  user "root"
end
cron "nba_refresh_current" do
  minute "0"
  hour "12"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:nba:refresh:current >> #{log_file_prefix}.nba_refresh_current_cron.log 2>&1"
  user "root"
end
cron "nfl_refresh_current" do
  minute "0"
  hour "12"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:nfl:refresh:current >> #{log_file_prefix}.nfl_refresh_current_cron.log 2>&1"
  user "root"
end
cron "nhl_refresh_current" do
  minute "0"
  hour "12"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:nhl:refresh:current >> #{log_file_prefix}.nhl_refresh_current_cron.log 2>&1"
  user "root"
end

# Refresh all data once a night at 3:15 am
# 15 7 * * * php app/console rant:stats:cbb:refresh:all >/dev/null 2>&1
# 15 7 * * * php app/console rant:stats:cfb:refresh:all >/dev/null 2>&1
# 15 7 * * * php app/console rant:stats:mlb:refresh:all >/dev/null 2>&1
# 15 7 * * * php app/console rant:stats:nba:refresh:all >/dev/null 2>&1
# 15 7 * * * php app/console rant:stats:nfl:refresh:all >/dev/null 2>&1
# 15 7 * * * php app/console rant:stats:nhl:refresh:all >/dev/null 2>&1

cron "cbb_refresh_all" do
  minute "15"
  hour "7"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:cbb:refresh:all >> #{log_file_prefix}.cbb_refresh_all_cron.log 2>&1"
  user "root"
end
cron "cfb_refresh_all" do
  minute "15"
  hour "7"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:cfb:refresh:all >> #{log_file_prefix}.cfb_refresh_all_cron.log 2>&1"
  user "root"
end
cron "mlb_refresh_all" do
  minute "15"
  hour "7"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:mlb:refresh:all >> #{log_file_prefix}.mlb_refresh_all_cron.log 2>&1"
  user "root"
end
cron "nba_refresh_all" do
  minute "15"
  hour "7"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:nba:refresh:all >> #{log_file_prefix}.nba_refresh_all_cron.log 2>&1"
  user "root"
end
cron "nfl_refresh_all" do
  minute "15"
  hour "7"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:nfl:refresh:all >> #{log_file_prefix}.nfl_refresh_all_cron.log 2>&1"
  user "root"
end
cron "nhl_refresh_all" do
  minute "15"
  hour "7"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:nhl:refresh:all >> #{log_file_prefix}.nhl_refresh_all_cron.log 2>&1"
  user "root"
end
