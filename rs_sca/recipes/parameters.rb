#
# Cookbook Name:: rs_sca
# Recipe:: parameters
#
# Copyright 2014, Rant Media Network
#
# All rights reserved - Do Not Redistribute
#
# Must run before application recipe to set configuration
# parameters prior to application installation
#
# encoding: UTF-8

Encoding.default_external = Encoding::UTF_8 if RUBY_VERSION > "1.9"

app_web_root = "#{node['rant']['nginx']['web_root']}/#{node['rant']['nginx']['vhost']}"

template "#{app_web_root}/current/config/parameters.yml.dist" do
    source 'parameters.yml.dist.erb'
    variables(
        :auth_endpoint  => node['rant']['application']['environment_vars']['RANT_APP_ENV_AUTHENTICATION_SERVER_AUTH'],
        :token_endpoint => node['rant']['application']['environment_vars']['RANT_APP_ENV_AUTHENTICATION_SERVER_TOKEN'],
        :user_endpoint  => node['rant']['application']['environment_vars']['RANT_APP_ENV_AUTHENTICATION_SERVER_USER']
    )
end