require "spurious/ruby/awssdk/helper/version"
require "aws-sdk"
require "json"

module Spurious
  module Ruby
    module Awssdk
      module Helper

        def self.port_config()
          config = `spurious ports --machine-readable`
          JSON.parse(config)
        rescue Exception
          raise("The spurious CLI tool didn't return the port configuration")
        end

        def self.configure(strategy = nil)

        end

      end
    end
  end
end
