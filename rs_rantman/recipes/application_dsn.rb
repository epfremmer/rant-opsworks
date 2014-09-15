#
# Cookbook Name:: rs_cassandra
# Recipe:: application_dsn
#
# Copyright 2014, Douglas Linsmeyer. All rights Reserved.
#
# Proprietary license.
#
# Setup the DSN configuration form the attached RDS instance. This must be run
# after the application install recipe
#

app_web_root = "#{node['rant']['nginx']['web_root']}/#{node['rant']['nginx']['vhost']}"

template "#{app_web_root}/current/app/config/databases.yml" do
  source "databases.yml.erb"
  owner node['rant']['deploy']['user']
  group node['rant']['deploy']['group']
  mode 0644
  variables(

  )
end

bash "clear_cache" do
    cwd "#{app_web_root}/current"
    code <<-EOH
        app/console cache:clear --env=#{node['rant']['application']['environment_name']}
    EOH
end
