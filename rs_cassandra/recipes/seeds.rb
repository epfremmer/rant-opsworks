#
# Cookbook Name:: rs_cassandra
# Recipe:: seeds
#
# Copyright 2014, Douglas Linsmeyer. All rights Reserved.
#
# Proprietary license.
#

layer_slug_name = node['opsworks']['instance']['layers'].first
layer_instances = node['opsworks']['layers'][layer_slug_name]['instances']
cluster_ips = []

layer_instances.each do |name, instance|
    cluster_ips << instance['private_ip']
end

template "#{node['cassandra']['conf_dir']}/cassandra.yaml" do
    source "cassandra.yaml.erb"
    owner node['cassandra']['user']
    group node['cassandra']['group']
    mode  0644
    notifies :restart, "service[cassandra]", :delayed
    variables(
        :seed_ips => cluster_ips
    )
end
