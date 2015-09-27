name 'operadriver'
maintainer 'Dennis Hoer'
maintainer_email 'dennis.hoer@gmail.com'
license 'MIT'
description 'Selenium WebDriver for Opera'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.0'

supports 'ubuntu'
supports 'windows'

depends 'windows', '~> 1.0'

source_url 'https://github.com/dhoer/chef-operadriver' if respond_to?(:source_url)
issues_url 'https://github.com/dhoer/chef-operadriver/issues' if respond_to?(:issues_url)
