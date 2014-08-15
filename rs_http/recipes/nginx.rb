# Delete all nginx configuration files and create virtualhost configuration
nginx_path = node['rant']['nginx']['config_dir']
app_web_root = "#{node['rant']['nginx']['web_root']}/#{node['rant']['nginx']['vhost']}"

ruby_block 'Clear nginx configuration' do
    block do
        Dir.foreach("#{nginx_path}/sites-enabled") {|f| fn = File.join("#{nginx_path}/sites-enabled", f); File.delete(fn) if f != '.' && f != '..'}
    end
end

directory app_web_root do
    action :create
    recursive true
    owner node['rant']['deploy']['user']
    group node['rant']['deploy']['group']
end

template "#{nginx_path}/sites-available/#{node['rant']['nginx']['vhost']}" do
    source "nginx#{node['rant']['nginx']['conf_type']}.conf.erb"
    mode '0700'
    variables(
        :vhost => node['rant']['nginx']['vhost'],
        :root_path => "#{app_web_root}/current/#{node['rant']['nginx']['web_sub_dir']}",
        :error_log_path => "#{node['rant']['nginx']['log_dir']}/#{node['rant']['nginx']['vhost']}.error.log",
        :access_log_path => "#{node['rant']['nginx']['log_dir']}/#{node['rant']['nginx']['vhost']}.access.log",
        :socket_path => node['rant']['php']['socket_dir'],
        :environment_name => node['rant']['application']['environment_name'],
        :env_vars => node['rant']['nginx']['env_vars']
    )
end

link "#{nginx_path}/sites-enabled/#{node['rant']['nginx']['vhost']}" do
    to "#{nginx_path}/sites-available/#{node['rant']['nginx']['vhost']}"
end

directory node['rant']['nginx']['web_root'] do
    owner node['rant']['deploy']['user']
    group node['rant']['deploy']['group']
    mode '0755'
    action :create
end

cookbook_file "index.php" do
    path "#{app_web_root}/index.php"
    owner node['rant']['deploy']['user']
    group node['rant']['deploy']['group']
    mode '0755'
    action :create_if_missing
end

service 'nginx' do
    action :restart
end
