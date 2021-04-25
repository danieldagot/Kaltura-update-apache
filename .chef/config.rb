# See https://docs.getchef.com/config_rb.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "master1"
client_key               "#{current_dir}/master1.pem"
chef_server_url          "https://3.236.103.139/organizations/dagotltd"
cookbook_path            ["#{current_dir}/../cookbooks"]
