require 'serverspec_helper'

describe 'selenium::operadriver' do
  if os[:family] == 'windows'
    describe file('C:/operadriver/operadriver.exe') do
      it { should be_file }
    end
  elsif !(os[:family] == 'redhat' && os[:release].split('.')[0] == '6')
    describe file('/usr/bin/operadriver') do
      it { should be_symlink }
    end
  end
end
