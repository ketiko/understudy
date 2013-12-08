require 'spec_helper'

describe Understudy::Config do
  describe ".from_file" do
    before do
      File.stub(:open)
      YAML.stub(:load).and_return({ a: 1 })
    end

    subject { Understudy::Config.from_file('mock_file.yml') }

    it 'load the file' do
      expect(subject.size).to be > 0
    end
  end
end
