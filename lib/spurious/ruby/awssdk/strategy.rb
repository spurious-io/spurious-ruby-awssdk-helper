require "spurious/ruby/awssdk/helper/version"
require "aws-sdk"

module Spurious
  module Ruby
    module Awssdk
      class Strategy
        def initialize(set_all = false)
          @mapping = {}
          return unless set_all

          dynamo
          sqs
          s3
        end

        def apply(config)
          mapping.each do |type, mappings|
            ports = config[type]
            Aws.config.update("#{mappings['identifier']}_port".to_sym => ports.first["HostPort"]) if mappings["port"]
            Aws.config.update("#{mappings['identifier']}_endpoint".to_sym => ports.first["Host"]) if mappings["ip"]
          end

          Aws.config.update(:use_ssl => false, :s3_force_path_style => true)
        end

        private

        attr_reader :mapping

        def dynamo(port = true, ip = true)
          mapping["spurious-dynamo"] = {
            "port"       => port,
            "ip"         => ip,
            "identifier" => "dynamo_db"
          }
        end

        def s3(port = true, ip = true)
          mapping["spurious-s3"] = {
            "port"       => port,
            "ip"         => ip,
            "identifier" => "s3"
          }
        end

        def sqs(port = true, ip = true)
          mapping["spurious-sqs"] = {
            "port"       => port,
            "ip"         => ip,
            "identifier" => "sqs"
          }
        end
      end
    end
  end
end
