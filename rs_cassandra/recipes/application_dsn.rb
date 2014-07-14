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

layer_slug_name = node['rant']['deploy']['db_layer_name']
layer_instances = node['opsworks']['layers'][layer_slug_name]['instances']
dsn_entries =[]

layer_instances.each do |name, instance|
  log "Cassandra cluster #{instance['private_ip']}"
  dsn_entries << "host=#{instance['private_ip']};port=#{node['cassandra']['rpc_port']}"
end

template "#{node['rant']['nginx']['web_root']}/#{node['rant']['nginx']['vhost']}/current/app/config/cassandra_cluster.yml" do
  source "cassandra_cluster.yml.erb"
  owner node['rant']['deploy']['user']
  group node['rant']['deploy']['group']
  mode 0644
  variables(
    :dsn => dsn_entries.join(",")
  )
end

