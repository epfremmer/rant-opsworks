#
# Cookbook Name:: rs_cassandra
# Recipe:: application_dsn
#
# Copyright 2014, Douglas Linsmeyer. All rights Reserved.
#
# Proprietary license.
#
# This recipe should be run on all HTTP/PHP & Cron servers when a Cassandra
# instance either comes online or goes offline. This recipe changes the
# Cassandra connection DSN.
#


#
# Iterate through the Cassandra layer collecting the instance IP addresses
#

app_web_root = "#{node['rant']['nginx']['web_root']}/#{node['rant']['nginx']['vhost']}"

layer_slug_name  = node['rant']['deploy']['db_layer_name']
layer_instances  = node['opsworks']['layers'][layer_slug_name]['instances']
snitch_instances = node['opsworks']['layers'].has_key?("cassandra-snitch") ? node['opsworks']['layers']['cassandra-snitch']['instances'] : []

cluster_nodes = []

# add internal seed ips
layer_instances.each do |name, instance|
  log "Cassandra cluster #{instance['private_ip']}"
  cluster_nodes << instance['private_ip']
end

# add internal snitch ips
snitch_instances.each do |name, instance|
  log "Cassandra cluster #{instance['private_ip']} [snitch]"
  cluster_nodes << instance['private_ip']
end

template "#{app_web_root}/current/app/config/cassandra_cluster.yml" do
  source "cassandra_cluster.yml.erb"
  owner node['rant']['deploy']['user']
  group node['rant']['deploy']['group']
  mode 0644
  variables(
    :instances => cluster_nodes,
    :port => node['rant']['cassandra']['port']
  )
end

bash "install_application" do
    cwd "#{app_web_root}/current"
    code <<-EOH
        app/console cache:clear --env=#{node['rant']['application']['environment_name']}
    EOH
end
