bit = '32'
case node['platform']
when 'windows'
  os = 'win'
when 'mac_os_x'
  os = 'mac'
else
  os = 'linux'
  bit = '64' if node['kernel']['machine'] == 'x86_64'
end
version = node['operadriver']['version']
name = "operadriver_#{os}#{bit}-#{version}"

if platform?('windows')
  home = node['operadriver']['windows']['home']
else
  home = node['operadriver']['unix']['home']
end

directory home do
  action :create
end

driver_path = "#{home}/#{name}"

directory driver_path do
  action :create
end

cache_path = "#{Chef::Config[:file_cache_path]}/#{name}.zip"

if platform?('windows')
  # TODO: Replace powershell and windows_zipfile with windows_zip
  # Fix windows_zipfile - rubyzip failure to allocate memory (requires PowerShell 3 or greater & .NET Framework 4)
  batch 'unzip operadriver' do
    code "powershell.exe -nologo -noprofile -command \"& { Add-Type -A 'System.IO.Compression.FileSystem';"\
      " [IO.Compression.ZipFile]::ExtractToDirectory('#{cache_path}', '#{driver_path}'); }\""
    action :nothing
    only_if { operadriver_powershell_version >= 3 }
  end

  windows_zipfile driver_path do
    source cache_path
    action :nothing
    not_if { operadriver_powershell_version >= 3 }
  end
end

package 'unzip' unless platform?('windows', 'mac_os_x')

execute 'unzip operadriver' do
  command "unzip -o #{cache_path} -d #{driver_path} && chmod -R 0755 #{driver_path}"
  action :nothing
end

remote_file 'download operadriver' do
  path cache_path
  source "#{node['operadriver']['url']}/v#{version}/operadriver_#{os}#{bit}.zip"
  use_etag true
  use_conditional_get true
  notifies :run, 'batch[unzip operadriver]', :immediately if platform?('windows')
  notifies :unzip, "windows_zipfile[#{driver_path}]", :immediately if platform?('windows')
  notifies :run, 'execute[unzip operadriver]', :immediately unless platform?('windows')
end

case node['platform_family']
when 'windows'
  link "#{home}/operadriver.exe" do
    to "#{driver_path}/operadriver.exe"
  end

  env 'operadriver path' do
    key_name 'PATH'
    action :modify
    delim ::File::PATH_SEPARATOR
    value home
  end
else # unix
  link '/usr/bin/operadriver' do
    to "#{driver_path}/operadriver"
  end
end
