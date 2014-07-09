require "spurious/ruby/awssdk/helper/version"
require "aws-sdk"

module Spurious
  module Ruby
    module Awssdk
      class Strategy
        attr_accessor :mapping

        def initialize
          @mapping = {}
        end

        def dynamo(port = true, ip = false)
          mapping['spurious-dynamo'] = {
            'port'       => port,
            'ip'         => ip,
            'identifier' => 'dynamo_db'
          }
        end

        def sqs(port = true, ip = false)
          mapping['spurious-sqs'] = {
            'port'       => port,
            'ip'         => ip,
            'identifier' => 'sqs'
          }
        end

        def s3(port = true, ip = false)
          mapping['spurious-s3'] = {
            'port'       => port,
            'ip'         => ip,
            'identifier' => 's3'
          }
        end

        def apply(config)
          mapping.each do |type, mappings|
            ports = config[type]
            AWS.config("#{mappings['identifier']}_port".to_sym => ports.first['HostPort']) if mappings['port']
            AWS.config("#{mappings['identifier']}_endpoint".to_sym => 'localhost') if mappings['ip']
          end
        end

      end
    end
  end
end
