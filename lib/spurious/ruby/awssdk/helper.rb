require "spurious/ruby/awssdk/helper/version"
require 'spurious/ruby/awssdk/strategy'
require "aws-sdk"
require "json"
require "uri"

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
          {
            "spurious-dynamo" => [
              {
                "Host"     => ENV['SPURIOUS.DYNAMODB.LOCAL_NAME'].split('/').last,
                "HostPort" => URI(ENV['SPURIOUS.DYNAMODB.LOCAL_PORT']).port
              }
            ],
            "spurious-sqs" => [
              {
                "Host"     => ENV['SPURIOUS.SQS.LOCAL_NAME'].split('/').last,
                "HostPort" => URI(ENV['SPURIOUS.SQS.LOCAL_PORT']).port
              }
            ],
            "spurious-s3" => [
              {
                "Host"     => ENV['SPURIOUS.S3.LOCAL_NAME'].split('/').last,
                "HostPort" => URI(ENV['SPURIOUS.S3.LOCAL_PORT']).port
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
