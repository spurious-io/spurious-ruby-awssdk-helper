require "spurious/ruby/awssdk/helper/version"
require 'spurious/ruby/awssdk/strategy'
require "aws-sdk"
require "json"

module Spurious
  module Ruby
    module Awssdk
      module Helper

        def self.port_config()
          config = `spurious ports --json`
          JSON.parse(config)
        rescue Exception
          raise("The spurious CLI tool didn't return the port configuration")
        end

        def self.configure(strategy = nil)
          strategy ||= Spurious::Ruby::Awssdk::Strategy.new(true)
          strategy.apply(port_config)
        end

      end
    end
  end
end
