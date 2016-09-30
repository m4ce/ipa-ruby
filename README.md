# Ruby client library for FreeIPA JSON API
This is a simple Ruby client library that allows to interact with the FreeIPA JSON API. It currently only supports authenticating via
Kerberos/GSSAPI tickets.

Pull requests to add additional API features are very welcome. I only implemented what I needed.

## Install
To install it simply issue the following command:

```
gem install ipa-ruby
```

## Usage

You can optionally pass a `ca_cert` keyword argument specifying the path to the FreeIPA CA certificate. Default is /etc/ipa/ca.crt.
```
require 'ipa/client'
ipa = IPA::Client.new(host: 'ipa.example.org')
```

Note that additional parameters can be passed via the `params` keyword argument.

Add a host (with a random password):
```
ipa.host_add(hostname: 'foo.example.org', force: true, random: true, all: true)
```

Add a host (with a specific password)
```
ipa.host_add(hostname: 'foo.example.org', force: true, userpassword: 'bar', all: true)
```

Delete a host:
```
ipa.host_del(hostname: 'foo.example.org')
```

Show a host:
```
ipa.host_show(hostname: 'foo.example.org', all: true)
```

Find hosts:
```
ipa.host_find(all: true, params: {:in_hostgroup => true})
```

Check if a host exists
```
if ipa.host_exists?('foo.example.org)
  puts "Yep :)"
else
  puts "Nope :("
end
```

## Todo

* Implement user API
* Implement group API
* Implement hostgroup API
* Implement sudocmd API
* Implement sudocmdgroup API
* Implement hbacrule API
* Implement hbacsvcgroup API

## Contact
Matteo Cerutti - matteo.cerutti@hotmail.co.uk
