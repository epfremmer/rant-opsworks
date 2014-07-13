#
# Cookbook Name:: rs_cassandra
# Recipe:: seeds
#
# Copyright 2014, Douglas Linsmeyer. All rights Reserved.
#
# Proprietary license.
#

layer_slug_name = node['opsworks']['instance']['layers'].first
layer_instances = node['opsworks']['layers'][replicaset_layer_slug_name]['instances']
cluster_ips = []

layer_instances.each_index do |n|
    cluster_ips << members[n]['ipaddress']
end

template "#{node['cassandra']['conf_dir']}/cassandra.yaml"
    source "cassandra.yaml.erb"
    owner node['cassandra']['user']
    group node['cassandra']['group']
    mode  0644
    notifies :restart, "service[cassandra]", :delayed
end
