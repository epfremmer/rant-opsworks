#
# Cookbook Name:: rs_cassandra
# Recipe:: snitch
#
# Copyright 2014, Douglas Linsmeyer. All rights Reserved.
#
# Proprietary license.
#
# This recipe must run on all Cassandra snitch servers when a new server
# comes online or if a server goes offline. Including the new server.
#
# It updates the cassandra.yaml configuration file for Cassandra
# to inform each node of all other nodes.
#

layer_instances  = node['opsworks']['layers']['cassandra']['instances']
snitch_instances = node['opsworks']['layers']['cassandra-snitch']['instances']

dc_name = node['cassandra']['dc_name']

snitch_ips  = node['cassandra']['snitch_ips']
cluster_ips = []

node.default['cassandra']['listen_address']    = node['opsworks']['instance']['private_ip']
node.default['cassandra']['broadcast_address'] = node['opsworks']['instance']['ip']

# add instance ip
cluster_ips << node['opsworks']['instance']['ip']

# add internal seed ips
layer_instances.each do |name, instance|
  log "Cassandra cluster #{instance['private_ip']}"
  cluster_ips << instance['private_ip']
end

# add internal snitch ips
snitch_instances.each do |name, instance|
  log "Cassandra cluster #{instance['private_ip']} [snitch]"
  cluster_ips << instance['private_ip']
end

# add external snitch ips
cluster_ips + snitch_ips

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
        :seed_ips => cluster_ips.join(",")
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