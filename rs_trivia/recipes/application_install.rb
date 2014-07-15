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
    mode 0744
end

directory "#{app_web_root}/current/craft/config" do
    owner node['rant']['deploy']['user']
    group node['rant']['deploy']['group']
    mode 0744
end

directory "#{app_web_root}/current/craft/storage" do
    owner node['rant']['deploy']['user']
    group node['rant']['deploy']['group']
    mode 0744
end

directory "#{app_web_root}/current" do
    owner node['rant']['deploy']['user']
    group node['rant']['deploy']['group']
end
