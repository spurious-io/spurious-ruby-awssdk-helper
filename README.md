# Spurious::Ruby::Awssdk::Helper

[![Build Status](https://travis-ci.org/spurious-io/ruby-awssdk-helper.png?branch=master)](https://travis-ci.org/spurious-io/ruby-awssdk-helper)
[![Gem Version](https://badge.fury.io/rb/spurious-ruby-awssdk-helper.png)](http://badge.fury.io/rb/spurious-ruby-awssdk-helper)

A ruby helper class for configuring the ruby `aws-sdk` to
talk to the spurious services.

## Installation

Add this line to your application's Gemfile:

    gem 'spurious-ruby-awssdk-helper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spurious-ruby-awssdk-helper

## Usage

You can configure the `aws-sdk` two different ways:

1. Shelling out to the CLI tool for the current port mappings
2. Getting current port mappings from linked docker containers

## CLI strategy

Generally you have this setup done at the entry point of your
application or in a di container:

```ruby
require 'spurious/ruby/awssdk/helper'

Spurious::Ruby::Awssdk::Helper.configure
```


## Docker strategy

If you're running you application in a container on the same host
as spurious then you can pass in the following linked containers:

```bash
docker run ... --link spurious-s3:s3.spurious.localhost --link spurious
-sqs:sqs.spurious.localhost --link spurious-dynamo:dynamodb.spurious.localhost
```

then inside your application:

```ruby
require 'spurious/ruby/awssdk/helper'

Spurious::Ruby::Awssdk::Helper.configure :docker

```

## Contributing

1. Fork it ( https://github.com/spurious-io/ruby-awssdk-helper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
