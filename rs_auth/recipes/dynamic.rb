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
dsn_entries =[]

layer_instances.each do |name, instance|
  log "MongoDB cluster #{instance['private_ip']}"
  dsn_entries << "#{instance['private_ip']}:#{node['mongodb']['config']['port']}"
end

template "#{app_web_root}/current/app/config/dynamic.yml" do
  source "dynamic.yml.erb"
  owner node['rant']['deploy']['user']
  group node['rant']['deploy']['group']
  mode 0644
  variables(
    :mongo_dsn => dsn_entries.join(",")
  )
end

bash "install_application" do
    cwd "#{app_web_root}/current"
    code <<-EOH
        sudo app/console cache:clear --env=#{node['rant']['application']['environment_name']}
        sudo chown -R #{node['rant']['deploy']['user']}:#{node['rant']['deploy']['group']} ./
    EOH
end
