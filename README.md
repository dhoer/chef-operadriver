# Selenium OperaDriver Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/operadriver.svg?style=flat-square)][supermarket]
[![Build Status](http://img.shields.io/travis/dhoer/chef-operadriver.svg?style=flat-square)][travis]

[supermarket]: https://supermarket.chef.io/cookbooks/operadriver
[travis]: https://travis-ci.org/dhoer/chef-operadriver

Installs OperaChromiumDriver (https://github.com/operasoftware/operachromiumdriver). 

## Requirements

- Chef 11.16+
- Chrome (this cookbook does not install Chrome)

### Platforms

- Ubuntu
- Windows

### Cookbooks

- windows 

## Usage

Include recipe in a run list or cookbook to install OperaChromiumDriver.

### Attributes

- `node['operadriver']['version']` - Version to download.
- `node['operadriver']['url']` -  URL download prefix.
- `node['operadriver']['windows']['home']` - Home directory for windows. Default `%SYSTEMDRIVE%\operadriver`.
- `node['operadriver']['unix']['home']` - Home directory for both linux and macosx. Default `/opt/operadriver`.

#### Install selenium node with opera capability

```ruby
include_recipe 'opera'
include_recipe 'operadriver'

node.set['selenium']['node']['capabilities'] = [
  {
    browserName: 'operablink',
    maxInstances: 1,
    version: opera_version,
    seleniumProtocol: 'WebDriver'
  }
]

include_recipe 'selenium::node'
```

## Getting Help

- Ask specific questions on [Stack Overflow](http://stackoverflow.com/questions/tagged/operadriver).
- Report bugs and discuss potential features in [Github issues](https://github.com/dhoer/chef-operadriver/issues).

## Contributing

Please refer to [CONTRIBUTING](https://github.com/dhoer/chef-operadriver/graphs/contributors).

## License

MIT - see the accompanying [LICENSE](https://github.com/dhoer/chef-operadriver/blob/master/LICENSE.md) file for 
details.
