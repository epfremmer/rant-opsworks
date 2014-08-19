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

aws_access_key_id     = node['awscli']['aws_access_key_id']
aws_secret_access_key = node['awscli']['aws_secret_access_key']

dc_name = node['cassandra']['dc_name']
cluster_ips = []

#layer_instances.each do |name, instance|
#  log "Cassandra cluster #{instance['ip']}"
#  cluster_ips << instance['ip']
#end

package "python-pip" do
    action :install
end

include_recipe "python"
require 'json'

python_pip "awscli"

#ENV['AWS_ACCESS_KEY_ID']     = aws_access_key_id
#ENV['AWS_SECRET_ACCESS_KEY'] = aws_secret_access_key

#log `printenv AWS_ACCESS_KEY_ID`
#log `printenv AWS_SECRET_ACCESS_KEY`

results = "/tmp/instances.json"

bash "write_instance_json" do
    user "root"
    cwd "/tmp"

    environment ({'AWS_ACCESS_KEY_ID' => "#{aws_access_key_id}", 'AWS_SECRET_ACCESS_KEY' => "#{aws_secret_access_key}"})

    code <<-EOH
        sudo /usr/local/bin/aws ec2 --region us-east-1 describe-instances --output json > #{results}
    EOH
end

bash "log_instance_json" do
    user "root"
    cwd "/tmp"

    environment ({'AWS_ACCESS_KEY_ID' => "#{aws_access_key_id}", 'AWS_SECRET_ACCESS_KEY' => "#{aws_secret_access_key}"})

    code <<-EOH
        sudo echo #{results}
    EOH
end

log $USER

file results do
  owner "root"
  group "root"
  mode "0777"
  action :create
end

#`export AWS_ACCESS_KEY_ID = #{aws_access_key_id}`
#`export AWS_SECRET_ACCESS_KEY = #{aws_secret_access_key}`
#instances = `sudo /usr/local/bin/aws ec2 --region us-east-1 describe-instances --output json`

ruby_block "Results" do
    only_if { ::File.exists?(results) }

    instances = JSON.parse(File.read(results))

    instances['Reservations'].each do |index, instance|
      if instance['Tags'].detect {|tag| tag['key'] == "opsworks:layer:cassandra"}
        cluster_ips << instance['PublicIpAddress']
        log "Cassandra cluster #{instance['PublicIpAddress']}"
      end
    end
end

#directory "/root/.aws" do
#  owner "root"
#  group "root"
#  mode 00644
#  action :create
#end

#file "/root/.aws/config" do
#  owner "root"
#  group "root"
#  mode "0700"
#  action :create
#end

#template "/root/.aws/config" do
#    source "awscli.config.erb"
#    action :create
#    mode  0700
#    variables(
#        :aws_access_key_id     => aws_access_key_id,
#        :aws_secret_access_key => aws_secret_access_key
#    )
#end

#instances['Reservations'].each do |index, instance|
#  if instance['Tags'].detect {|tag| tag['key'] == "opsworks:layer:cassandra"}
#    cluster_ips << instance['PublicIpAddress']
#    log "Cassandra cluster #{instance['PublicIpAddress']}"
#  end
#end

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