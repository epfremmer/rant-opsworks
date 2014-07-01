include_recipe "mongodb::default"

mongodb_instance "mongodb" do
  port node['mongodb']['port']
  dbpath node['mongodb']['dbpath']
end
