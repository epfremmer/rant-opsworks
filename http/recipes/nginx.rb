# Delete all nginx configuration files and create virtualhost configuration
nginx_path = node['rant']['nginx']['config_dir']
app_web_root = "#{node['rant']['nginx']['web_root']}/#{node['rant']['nginx']['vhost']}"

ruby_block 'Clear nginx configuration' do
    block do
        Dir.foreach(dir_path) {|f| fn = File.join(dir_path, f); File.delete(fn) if f != '.' && f != '..'}
    end
end

# Be sure that the vhost folder exists and it's owned by www user
FileUtils.mkdir_p "#{nginx_path}/sites-enabled"

directory app_web_root do
    owner node['rant']['deploy_user']
    group node['rant']['deploy_group']
end

template "#{nginx_path}/sites-available/#{node['rant']['nginx']['vhost']}" do
    source 'nginx.conf.erb'
    mode '0700'
    variables(
        :vhost => node['rant']['nginx']['vhost'],
        :root_path => app_web_root,
        :error_log_path => "#{node['rant']['nginx']['log_dir']}/#{node['rant']['nginx']['vhost']}.error.log",
        :access_log_path => "#{node['rant']['nginx']['log_dir']}/#{node['rant']['nginx']['vhost']}.access.log",
        :socket_path => node['rant']['php']['socket_dir']
    )
end

directory node['rant']['nginx']['web_root'] do
    owner node['rant']['deploy_user']
    owner node['rant']['deploy_group']
    mode '0755'
    action :create
end

service 'nginx' do
    supports :status => true, :start => true, :stop => true, :restart => true
    action [ :enable, :restart ]
end
