include_recipe 'java_se'
include_recipe 'selenium::hub'
include_recipe 'xvfb' unless platform?('windows', 'mac_os_x')

execute 'sudo apt-get update' do
  action :nothing
  only_if { platform_family?('debian') }
end.run_action(:run)

include_recipe 'opera'
include_recipe 'operadriver'

if platform?('windows', 'mac_os_x')
  node.set['selenium']['node']['username'] = 'vagrant'
  node.set['selenium']['node']['password'] = 'vagrant'
end

node.set['selenium']['node']['capabilities'] = [
  {
    browserName: 'operablink',
    maxInstances: 5,
    version: opera_version,
    seleniumProtocol: 'WebDriver'
  }
]

include_recipe 'selenium::node'
