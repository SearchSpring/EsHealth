require 'spec_helper'
require 'socket'
require 'json'

describe Eshealth::GraphiteMetrics do
  describe "Attributes" do
    graphite = Eshealth::GraphiteMetrics.new
    it "Should allow reading and writing for :host" do
      graphite.host = "something_stupid"
      expect(graphite.host).to eq "something_stupid"
    end
    it "Should allow reading and writing for :port" do
      graphite.port = 2003
      expect(graphite.port).to eq(2003) 
    end
  end
  describe "Methods" do
    before(:context) do
      @server = TCPServer.new('127.0.0.1', 12003)
    end
    after(:context) do
      @server.close
    end
    graphite = Eshealth::GraphiteMetrics.new(:host => "localhost", :port => 12003)
    describe "#trigger" do
      it "Should not raise error" do
        expect { graphite.trigger }.to_not raise_error()
      end
    end
    describe "#clear" do
      it "Should return true" do
        expect(graphite.clear).to be_truthy
      end
    end
  end
end