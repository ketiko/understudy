require 'spec_helper'

describe Understudy::CLI do
  let(:cli) { Understudy::CLI.new }
  let(:job) { "job_name" }

  describe "#perform" do
    subject { cli.perform(job) }

    it 'loads the config file' do
      expect(subject).to eq false
    end
  end
end
