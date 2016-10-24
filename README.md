# Eshealth

This gem is a pluggable library for creating health checks for Elasticsearch.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'eshealth'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eshealth

## Usage

### bin/eshealth

```
Usage: eshealth [OPTIONS]
    -u, --url=http://your_url:9200   URL to ES server
    -p, --period=N                   Number of minutes between checks
    -f, --failures=N                 Number of consecutive failures to trigger an alert
    -c, --condition=STRING           String matching a successful healthcheck
    -q, --quell=N                    Amount of time to quell between alerts
    -k, --key=SERVICEKEY             PagerDuty service key
    -n, --check=CHECKNAME            Name of check to perform, default: clusterhealth, options: clusterhealth,clusterconfig,clusterfs
        --percentage                 Percentage to alert about when the check is a percentage based check (default 20)
```

### Docker

https://hub.docker.com/r/searchspring/eshealth/

```
docker pull searchspring/eshealth
```

```
docker run --rm searchspring/eshealth -u http://ES_SERVER_HOSTNAME:9200/ -p 1 -c green -q 1 -f 1 -k PAGERDUTY_SERVICE_KEY
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SearchSpring/EsHealth . This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

