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

link "/etc/php5/fpm/conf.d/20-mcrypt.ini" do
    to "/etc/php5/mods-available/mcrypt.ini"
    only_if "test -L /etc/php5/mods-available/mcrypt.ini"
end

template "/etc/php5/mods-available/craft.ini" do
    source "php5_craft_ini.erb"
    mode '0700'
end

link "/etc/php5/fpm/conf.d/90-craft.ini" do
    to "/etc/php5/mods-available/craft.ini"
    only_if "test -L /etc/php5/mods-available/craft.ini"
end
