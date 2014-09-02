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

app_web_root = "#{node['rant']['nginx']['web_root']}/#{node['rant']['nginx']['vhost']}"
log_file     = "#{node['rant']['nginx']['log_dir']}/#{node['rant']['nginx']['vhost']}.cron.log"
app_env      = "#{node['rant']['application']['environment_name']}"

# Refresh current games every 5 minutes during active hours
# */5 0-3,8-23 * * * php app/console rant:stats:cbb:refresh:games:current >/dev/null 2>&1
# */5 0-3,8-23 * * * php app/console rant:stats:cfb:refresh:games:current >/dev/null 2>&1
# */5 0-3,8-23 * * * php app/console rant:stats:mlb:refresh:games:current >/dev/null 2>&1
# */5 0-3,8-23 * * * php app/console rant:stats:nba:refresh:games:current >/dev/null 2>&1
# */5 0-3,8-23 * * * php app/console rant:stats:nfl:refresh:games:current >/dev/null 2>&1
# */5 0-3,8-23 * * * php app/console rant:stats:nhl:refresh:games:current >/dev/null 2>&1

cron "cbb_refresh_games" do
  minute "*/5"
  hour "0-3,8-23"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:cbb:refresh:games:current >/dev/null 2>&1"
  user "root"
end
cron "cfb_refresh_games" do
  minute "*/5"
  hour "0-3,8-23"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:cfb:refresh:games:current >/dev/null 2>&1"
  user "root"
end
cron "mlb_refresh_games" do
  minute "*/5"
  hour "0-3,8-23"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:mlb:refresh:games:current >/dev/null 2>&1"
  user "root"
end
cron "nba_refresh_games" do
  minute "*/5"
  hour "0-3,8-23"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:nba:refresh:games:current >/dev/null 2>&1"
  user "root"
end
cron "nfl_refresh_games" do
  minute "*/5"
  hour "0-3,8-23"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:nfl:refresh:games:current >/dev/null 2>&1"
  user "root"
end
cron "nhl_refresh_games" do
  minute "*/5"
  hour "0-3,8-23"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:nhl:refresh:games:current >/dev/null 2>&1"
  user "root"
end

# Refresh current teams every 15 minutes during active hours
# 3,18,33,48 0-3,8-23 * * * php app/console rant:stats:cbb:refresh:teams:current >/dev/null 2>&1
# 3,18,33,48 0-3,8-23 * * * php app/console rant:stats:cfb:refresh:teams:current >/dev/null 2>&1
# 3,18,33,48 0-3,8-23 * * * php app/console rant:stats:mlb:refresh:teams:current >/dev/null 2>&1
# 3,18,33,48 0-3,8-23 * * * php app/console rant:stats:nba:refresh:teams:current >/dev/null 2>&1
# 3,18,33,48 0-3,8-23 * * * php app/console rant:stats:nfl:refresh:teams:current >/dev/null 2>&1
# 3,18,33,48 0-3,8-23 * * * php app/console rant:stats:nhl:refresh:teams:current >/dev/null 2>&1

cron "cbb_refresh_teams" do
  minute "3,18,33,48"
  hour "0-3,8-23"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:cbb:refresh:teams:current >/dev/null 2>&1"
  user "root"
end
cron "cfb_refresh_teams" do
  minute "3,18,33,48"
  hour "0-3,8-23"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:cfb:refresh:teams:current >/dev/null 2>&1"
  user "root"
end
cron "mlb_refresh_teams" do
  minute "3,18,33,48"
  hour "0-3,8-23"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:mlb:refresh:teams:current >/dev/null 2>&1"
  user "root"
end
cron "nba_refresh_teams" do
  minute "3,18,33,48"
  hour "0-3,8-23"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:nba:refresh:teams:current >/dev/null 2>&1"
  user "root"
end
cron "nfl_refresh_teams" do
  minute "3,18,33,48"
  hour "0-3,8-23"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:nfl:refresh:teams:current >/dev/null 2>&1"
  user "root"
end
cron "nhl_refresh_teams" do
  minute "3,18,33,48"
  hour "0-3,8-23"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:nhl:refresh:teams:current >/dev/null 2>&1"
  user "root"
end

# Refresh current players every hour during active hours
# 0 0-3,8-23 * * * php app/console rant:stats:cbb:refresh:players:current >/dev/null 2>&1
# 0 0-3,8-23 * * * php app/console rant:stats:cfb:refresh:players:current >/dev/null 2>&1
# 0 0-3,8-23 * * * php app/console rant:stats:mlb:refresh:players:current >/dev/null 2>&1
# 0 0-3,8-23 * * * php app/console rant:stats:nba:refresh:players:current >/dev/null 2>&1
# 0 0-3,8-23 * * * php app/console rant:stats:nfl:refresh:players:current >/dev/null 2>&1
# 0 0-3,8-23 * * * php app/console rant:stats:nhl:refresh:players:current >/dev/null 2>&1

cron "cbb_refresh_players" do
  minute "0"
  hour "0-3,8-23"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:cbb:refresh:players:current >/dev/null 2>&1"
  user "root"
end
cron "cfb_refresh_players" do
  minute "0"
  hour "0-3,8-23"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:cfb:refresh:players:current >/dev/null 2>&1"
  user "root"
end
cron "mlb_refresh_players" do
  minute "0"
  hour "0-3,8-23"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:mlb:refresh:players:current >/dev/null 2>&1"
  user "root"
end
cron "nba_refresh_players" do
  minute "0"
  hour "0-3,8-23"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:nba:refresh:players:current >/dev/null 2>&1"
  user "root"
end
cron "nfl_refresh_players" do
  minute "0"
  hour "0-3,8-23"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:nfl:refresh:players:current >/dev/null 2>&1"
  user "root"
end
cron "nhl_refresh_players" do
  minute "0"
  hour "0-3,8-23"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:nhl:refresh:players:current >/dev/null 2>&1"
  user "root"
end

# Refresh all data once a night at 3:00 am
# 0 3 * * * php app/console rant:stats:cbb:refresh:all >/dev/null 2>&1
# 0 3 * * * php app/console rant:stats:cfb:refresh:all >/dev/null 2>&1
# 0 3 * * * php app/console rant:stats:mlb:refresh:all >/dev/null 2>&1
# 0 3 * * * php app/console rant:stats:nba:refresh:all >/dev/null 2>&1
# 0 3 * * * php app/console rant:stats:nfl:refresh:all >/dev/null 2>&1
# 0 3 * * * php app/console rant:stats:nhl:refresh:all >/dev/null 2>&1

cron "cbb_refresh_all" do
  minute "0"
  hour "3"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:cbb:refresh:all >/dev/null 2>&1"
  user "root"
end
cron "cfb_refresh_all" do
  minute "0"
  hour "3"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:cfb:refresh:all >/dev/null 2>&1"
  user "root"
end
cron "mlb_refresh_all" do
  minute "0"
  hour "3"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:mlb:refresh:all >/dev/null 2>&1"
  user "root"
end
cron "nba_refresh_all" do
  minute "0"
  hour "3"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:nba:refresh:all >/dev/null 2>&1"
  user "root"
end
cron "nfl_refresh_all" do
  minute "0"
  hour "3"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:nfl:refresh:all >/dev/null 2>&1"
  user "root"
end
cron "nhl_refresh_all" do
  minute "0"
  hour "3"
  action :create
  command "#{app_web_root}/current/app/console --env=#{app_env} rant:stats:nhl:refresh:all >/dev/null 2>&1"
  user "root"
end
