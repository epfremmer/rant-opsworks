#
# Cookbook Name:: rs_cassandra
# Recipe:: application_dsn
#
# Copyright 2014, Douglas Linsmeyer. All rights Reserved.
#
# Proprietary license.
#
# This recipe should be run on all HTTP/PHP servers when a Cassandra instance
# either comes online or goes offline. This recipe changes the Cassandra
# connection DSN.
#


#
# Iterate through the Cassandra layer collecting the instance IP addresses
#

app_web_root = "#{node['rant']['nginx']['web_root']}/#{node['rant']['nginx']['vhost']}"
layer_slug_name = node['rant']['deploy']['db_layer_name']
layer_instances = node['opsworks']['layers'][layer_slug_name]['instances']

template "#{app_web_root}/current/app/config/cassandra_cluster.yml" do
  source "cassandra_cluster.yml.erb"
  owner node['rant']['deploy']['user']
  group node['rant']['deploy']['group']
  mode 0644
  variables(
    :instances => layer_instances,
    :port => node['rant']['cassandra']['port']
  )
end

bash "install_application" do
    cwd "#{app_web_root}/current"
    code <<-EOH
        app/console cache:clear --env=#{node['rant']['application']['environment_name']}
    EOH
end
