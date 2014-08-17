#
# Cookbook Name:: rs_cassandra
# Recipe:: seeds
#
# Copyright 2014, Douglas Linsmeyer. All rights Reserved.
#
# Proprietary license.
#
# This recipe must run on all Cassandra servers when a new server
# comes online or if a server goes offline. Including the new server.
#
# It updates the cassandra.yaml configuration file for Cassandra
# to inform each node of all other nodes.
#

layer_slug_name = node['opsworks']['instance']['layers'].first
layer_instances = node['opsworks']['layers'][layer_slug_name]['instances']

snitch_type = "Ec2MultiRegionSnitch"
dc_name     = node['cassandra']['dc_name']
cluster_ips = []

layer_instances.each do |name, instance|
  log "Cassandra cluster #{instance['ip']}"
  cluster_ips << instance['ip']
end

service "cassandra" do
  supports :restart => true, :status => true
  service_name "cassandra"
  action [:enable, :start]
end

template "#{node['cassandra']['conf_dir']}/cassandra.yaml" do
    source "cassandra.yaml.erb"
    owner node['cassandra']['user']
    group node['cassandra']['group']
    mode  0644
    notifies :restart, "service[cassandra]", :delayed
    variables(
        :seed_ips => cluster_ips.join(","),
        :snitch   => snitch_type
    )
end

template "#{node['cassandra']['conf_dir']}/cassandra-topology.yaml" do
    source "cassandra-topology.yaml.erb"
    owner node['cassandra']['user']
    group node['cassandra']['group']
    mode  0644
    notifies :restart, "service[cassandra]", :delayed
    variables(
        :dc_name => "#{dc_name}"
    )
end

template "#{node['cassandra']['conf_dir']}/cassandra-topology.properties" do
    source "cassandra-topology.properties.erb"
    owner node['cassandra']['user']
    group node['cassandra']['group']
    mode  0644
    notifies :restart, "service[cassandra]", :delayed
    variables(
        :dc_name => "#{dc_name}"
    )
end