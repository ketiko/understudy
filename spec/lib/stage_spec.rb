require 'spec_helper'

describe Understudy::Stage do
  describe "#setup" do
    before(:each) do
      Understudy::Stage.setup
    end

    it "should create the default configuration directory" do
      File.exists?(Understudy::Stage::DEFAULT_DIRECTORY).should be_true
    end

    it "should a configuration file for the machine" do
      File.exists?(File.join(Understudy::Stage::DEFAULT_DIRECTORY, "#{`hostname`.chomp}.config")).should be_true
    end
  end
end

