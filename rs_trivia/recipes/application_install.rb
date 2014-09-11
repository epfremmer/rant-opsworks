app_web_root = "#{node['rant']['nginx']['web_root']}/#{node['rant']['nginx']['vhost']}"

application node['rant']['application']['name'] do
    path "#{app_web_root}"
    owner node['rant']['deploy']['user']
    group node['rant']['deploy']['group']

    repository node['rant']['deploy']['repository']
    revision node['rant']['deploy']['branch']
end

directory "#{app_web_root}/current/craft/app" do
    owner node['rant']['deploy']['user']
    group node['rant']['deploy']['group']
    mode 0755
end

directory "#{app_web_root}/current/craft/config" do
    owner node['rant']['deploy']['user']
    group node['rant']['deploy']['group']
    mode 0755
end

directory "#{app_web_root}/current/craft/storage" do
    owner node['rant']['deploy']['user']
    group node['rant']['deploy']['group']
    mode 0755
end

directory "#{app_web_root}/current" do
    owner node['rant']['deploy']['user']
    group node['rant']['deploy']['group']
end

log "pre mcrypt link on conf.d"
execute "ls -l /etc/php5/fpm/conf.d/" do
end

link "/etc/php5/fpm/conf.d/20-mcrypt.ini" do
    to "/etc/php5/mods-available/mcrypt.ini"
end
execute "ln -sfn /etc/php5/mods-available/mcrypt.ini /etc/php5/fpm/conf.d/21-mcrypt.ini" do
end

template "/etc/php5/mods-available/craft.ini" do
    source "php5_craft_ini.erb"
    mode '0644'
end

link "/etc/php5/fpm/conf.d/30-craft.ini" do
    to "/etc/php5/mods-available/craft.ini"
end

service 'php5-fpm' do
    action :restart
end