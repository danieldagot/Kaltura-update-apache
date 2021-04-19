execute "update-upgrade" do
    command "sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade"
      action :run
end
package 'apache2'

file '/var/www/html/index.html' do
  content " Hello#{node['username']} <p id='date'></p>
  <script>
  n =  new Date();
  y = n.getFullYear();
  m = n.getMonth() + 1;
  d = n.getDate();
  document.getElementById('date').innerHTML = Date();
  </script>"
end
service 'apache2' do
  action [ :enable, :start ]
end