node.override['chef_client']["daemon_options"] = ["-z", "-c", "/etc/chef/solo.rb", "-j", "/etc/chef/node.json"]
node.override['chef_client']["init_style"] = "runit"
node.override['chef_client']["interval"] = 60
node.override['chef_client']["splay"] = 0
