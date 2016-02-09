require "helper"
require "spurious/ruby/awssdk/strategy"

describe Spurious::Ruby::Awssdk::Strategy do
  subject { described_class.new set_all }

  before do
    allow(Aws).to receive(:config).with(no_args) { mock_config }
  end

  let(:config) {
    {
      "spurious-sqs" => [
        {
          "GuestPort" => 123,
          "HostPort"  => 456,
          "Host"      => "foo"
        }
      ],
      "spurious-s3" => [
        {
          "GuestPort" => 789,
          "HostPort"  => 101,
          "Host"      => "foo"
        }
      ],
      "spurious-dynamo" => [
        {
          "GuestPort" => 121,
          "HostPort"  => 314,
          "Host"      => "foo"
        }
      ]
    }
  }
  let(:mock_config) { Hash.new }
  let(:set_all) { true }

  describe "#apply" do
    context "applys ports to all services" do
      specify do
        expect(mock_config).to receive(:update).exactly(7).times
        subject.apply config
      end
    end

    context "applys ports to 0 services" do
      let(:set_all) { false }
      specify do
        expect(mock_config).to receive(:update).exactly(1).times
        subject.apply config
      end
    end

    it "only applys a subset of the options" do
      subject.dynamo(true, true)

      expect(Aws).to receive(:config).exactly(3).times
      subject.apply(config)
    end

    it "only sets the port for one service" do
      subject.dynamo(true)

      expect(Aws).to receive(:config).with(:dynamo_db_port => 314)
      expect(Aws).to receive(:config).with(:dynamo_db_endpoint => "foo")
      expect(Aws).to receive(:config).with({:use_ssl=>false, :s3_force_path_style=>true})
      subject.apply(config)
    end
  end
end
