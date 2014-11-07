require "spurious/ruby/awssdk/helper/version"
require 'spurious/ruby/awssdk/strategy'
require "aws-sdk"
require "json"

module Spurious
  module Ruby
    module Awssdk
      module Helper

        def self.port_config
          config = `spurious ports --json`
          JSON.parse(config)
        rescue Exception
          raise("The spurious CLI tool didn't return the port configuration")
        end

        def self.docker_config
          regex     = /\/(?<host>[0-9\.]+):(?<port>[0-9]+)/
          dynamo_db = regex.match(ENV['SPURIOUS_DYNAMODB_PORT'])
          s3        = regex.match(ENV['SPURIOUS_S3_PORT'])
          sqs       = regex.match(ENV['SPURIOUS_SQS_PORT'])

          {
            "spurious-dynamo" => [
              {
                "Host"     => dynamo_db[:host],
                "HostPort" => dynamo_db[:port]
              }
            ],
            "spurious-sqs" => [
              {
                "Host"     => sqs[:host],
                "HostPort" => sqs[:port]
              }
            ],
            "spurious-s3" => [
              {
                "Host"     => s3[:host],
                "HostPort" => s3[:port]
              }
            ]
          }
        end

        def self.config(type)
          case type
          when :cli
            port_config
          when :docker
            docker_config
          end
        end

        def self.configure(type = :cli, strategy = nil)
          strategy ||= Spurious::Ruby::Awssdk::Strategy.new(true)
          strategy.apply(config(type))
        end

      end
    end
  end
end
