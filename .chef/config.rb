# See https://docs.getchef.com/config_rb.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "master1"
client_key               "#{current_dir}/master1.pem"
chef_server_url          "https://ip-172-31-71-132.ec2.internal/organizations/dagotltd"
cookbook_path            ["#{current_dir}/../cookbooks"]
knife[:validation_key_url] = 'https://kaltura-ec2-keys.s3.amazonaws.com/jenkins-aws-key.pem'
