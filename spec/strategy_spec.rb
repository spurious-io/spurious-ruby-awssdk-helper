require "helper"
require "spurious/ruby/awssdk/strategy"

describe Spurious::Ruby::Awssdk::Strategy do
  subject { described_class.new set_all }

  before do
    allow(Aws).to receive(:config).with(no_args) { mock_config }
  end

  let(:config) do
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
  end
  let(:mock_config) do
    instance_double(
      "Hash",
      :update => nil
    )
  end
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
  end

  describe "#dynamo" do
    let(:set_all) { false }
    before { subject.dynamo(true, true) }

    context "sets ports just for this service" do
      specify do
        expect(mock_config).to receive(:update).exactly(3).times
        subject.apply config
      end
    end

    specify do
      expect(mock_config).to receive(:update).with(:dynamo_db_port => 314).once
      subject.apply config
    end

    specify do
      expect(mock_config).to receive(:update).with(:dynamo_db_endpoint => "foo").once
      subject.apply config
    end
  end

  describe "#s3" do
    let(:set_all) { false }
    before { subject.s3(true, true) }

    context "sets ports just for this service" do
      specify do
        expect(mock_config).to receive(:update).exactly(3).times
        subject.apply config
      end
    end

    specify do
      expect(mock_config).to receive(:update).with(:s3_port => 101).once
      subject.apply config
    end

    specify do
      expect(mock_config).to receive(:update).with(:s3_endpoint => "foo").once
      subject.apply config
    end
  end

  describe "#sqs" do
    let(:set_all) { false }
    before { subject.sqs(true, true) }

    context "sets ports just for this service" do
      specify do
        expect(mock_config).to receive(:update).exactly(3).times
        subject.apply config
      end
    end

    specify do
      expect(mock_config).to receive(:update).with(:sqs_port => 456).once
      subject.apply config
    end

    specify do
      expect(mock_config).to receive(:update).with(:sqs_endpoint => "foo").once
      subject.apply config
    end
  end
end
