require 'helper'

describe Spurious::Ruby::Awssdk::Strategy do

  describe "#apply" do
    let(:config) {
      {
        'spurious-sqs' => [
          {
            'GuestPort' => 123,
            'HostPort'  => 456
          }
        ],
        'spurious-s3' => [
          {
            'GuestPort' => 789,
            'HostPort'  => 101
          }
        ],
        'spurious-dynamo' => [
          {
            'GuestPort' => 121,
            'HostPort'  => 314
          }
        ]
      }
    }

    it "applys ports from config" do
      subject.dynamo
      subject.sqs
      subject.s3

      expect(AWS).to receive(:config).exactly(3).times
      subject.apply(config)

    end

    it "only applys a subset of the options" do
      subject.dynamo(true, true)

      expect(AWS).to receive(:config).exactly(2).times
      subject.apply(config)

    end

    it "only sets the port for one service" do
      subject.dynamo(true)

      expect(AWS).to receive(:config).once.with(:dynamo_db_port => 314).times
      subject.apply(config)

    end

  end
end
