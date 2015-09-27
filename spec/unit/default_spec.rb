require 'spec_helper'

describe 'operadriver::default' do
  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(file_cache_path: 'C:/chef/cache', platform: 'windows', version: '2008R2') do
        ENV['SYSTEMDRIVE'] = 'C:'
      end.converge(described_recipe)
    end

    it 'creates home directory' do
      expect(chef_run).to create_directory('C:/operadriver')
    end

    it 'creates sub-directory' do
      expect(chef_run).to create_directory('C:/operadriver/operadriver_win32-0.2.2')
    end

    it 'downloads driver' do
      expect(chef_run).to create_remote_file('download operadriver').with(
        path: "#{Chef::Config[:file_cache_path]}/operadriver_win32-0.2.2.zip",
        source: 'https://github.com/operasoftware/operachromiumdriver/releases/download/v0.2.2/operadriver_win32.zip'
      )
    end

    it 'unzips via powershell' do
      expect(chef_run).to_not run_batch('unzip operadriver').with(
        code: "powershell.exe -nologo -noprofile -command \"& { Add-Type -A "\
          "'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory("\
          "'C:/chef/cache/operadriver_win32.zip', "\
          "'C:/operadriver/operadriver_win32-0.2.2'); }\"")
    end

    it 'unzips via window_zipfile' do
      expect(chef_run).to_not unzip_windows_zipfile_to('C:/operadriver/operadriver_win32-0.2.2').with(
        source: 'C:/chef/cache/operadriver_win32.zip'
      )
    end

    it 'links driver' do
      expect(chef_run).to create_link('C:/operadriver/operadriver.exe').with(
        to: 'C:/operadriver/operadriver_win32-0.2.2/operadriver.exe'
      )
    end

    it 'sets PATH' do
      expect(chef_run).to modify_env('operadriver path').with(
        key_name: 'PATH',
        value: 'C:/operadriver'
      )
    end
  end

  context 'linux' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        file_cache_path: '/var/chef/cache', platform: 'centos', version: '7.0').converge(described_recipe)
    end

    it 'creates home directory' do
      expect(chef_run).to create_directory('/opt/operadriver')
    end

    it 'creates sub-directory' do
      expect(chef_run).to create_directory('/opt/operadriver/operadriver_linux64-0.2.2')
    end

    it 'downloads driver' do
      expect(chef_run).to create_remote_file('download operadriver').with(
        path: "#{Chef::Config[:file_cache_path]}/operadriver_linux64-0.2.2.zip",
        source: 'https://github.com/operasoftware/operachromiumdriver/releases/download/v0.2.2/operadriver_linux64.zip'
      )
    end

    it 'unzips driver' do
      expect(chef_run).to_not run_execute('unzip operadriver')
    end

    it 'installs zip package' do
      expect(chef_run).to install_package('unzip')
    end

    it 'links driver' do
      expect(chef_run).to create_link('/usr/bin/operadriver').with(
        to: '/opt/operadriver/operadriver_linux64-0.2.2/operadriver'
      )
    end
  end

  context 'mac_os_x' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        file_cache_path: '/var/chef/cache', platform: 'mac_os_x', version: '10.10').converge(described_recipe)
    end

    it 'creates directory' do
      expect(chef_run).to create_directory('/opt/operadriver/operadriver_mac32-0.2.2')
    end

    it 'downloads driver' do
      expect(chef_run).to create_remote_file('download operadriver').with(
        path: "#{Chef::Config[:file_cache_path]}/operadriver_mac32-0.2.2.zip",
        source: 'https://github.com/operasoftware/operachromiumdriver/releases/download/v0.2.2/operadriver_mac32.zip'
      )
    end

    it 'links driver' do
      expect(chef_run).to create_link('/usr/bin/operadriver').with(
        to: '/opt/operadriver/operadriver_mac32-0.2.2/operadriver'
      )
    end
  end
end
