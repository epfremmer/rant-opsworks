app_web_root = "#{node['rant']['nginx']['web_root']}/#{node['rant']['nginx']['vhost']}"

application node['rant']['application']['name'] do
    path "#{app_web_root}"
    owner node['rant']['deploy']['user']
    group node['rant']['deploy']['group']

    repository node['rant']['deploy']['repository']
    revision node['rant']['deploy']['branch']
end

log "Setting application environment vars..."

node['rant']['application']['environment_vars'].each do |parameter, value|
    log "#{parameter}: #{value}"
    ENV[parameter] = value
end

log "Installing dependencies..."

bash "install_application" do
    cwd "#{app_web_root}/current"
    code <<-EOH
        bin/composer install --no-dev --verbose --prefer-dist --optimize-autoloader --no-interaction -vvv
    EOH
end

directory "#{app_web_root}/current" do
    owner node['rant']['deploy']['user']
    group node['rant']['deploy']['group']
end
