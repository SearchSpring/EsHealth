require "spec_helper"
require "json"

describe Eshealth::Metrics do
  describe "Attributes" do
    metrics = Eshealth::Metrics.new
    it "Allows reading and writing for :url" do
      metrics.url = "something_stupid"
      expect(metrics.url).to eq("something_stupid")
    end
    it "Allows reading and writing for :type" do
      metrics.type = "something_stupid"
      expect(metrics.type).to eq("something_stupid")
    end
    it "Allows reading and writing for :metrics and metrics must be an array" do
      metrics.metrics = ["something_stupid"]
      expect(metrics.metrics).to eq(["something_stupid"])
      expect { metrics.metrics = "something_stupid" }.to raise_error("metrics must be an Array not a String")
    end
    it "Allows reading and writing for :prefix" do
      metrics.prefix = "something_stupid"
      expect(metrics.prefix).to eq("something_stupid")
    end
    it "Allows reading and writing for :lastmsg" do
      metrics.lastmsg = "something_stupid"
      expect(metrics.lastmsg).to eq("something_stupid")
    end
    describe ".requestfactory" do
      it "Allows reading and writing for :requestfactory" do
        metrics.requestfactory = Eshealth::FakeRequest.new
        expect(metrics.requestfactory).to be_a(Eshealth::FakeRequest)
      end
      it "And it must be a Eshealth::RequestFactory" do
        expect { metrics.requestfactory = "something_stupid" }.to raise_error("requestfactory must be a 'Eshealth::Requestfactory' not a Object")
      end
    end
  end
  describe "Methods" do
    describe "#healthstatus" do
      response = {
        "nodes" => {
          "host" => {
            "name" => "something_stupid",
            "something_stupid" => "something_stupid" 
          }
        }
      }.to_json
      requestfactory = Eshealth::FakeRequest.new(:response => response )
      metrics = Eshealth::Metrics.new(
        :url => "localhost", 
        :metrics => ["something_stupid"],
        :prefix => "something_stupid",
        :requestfactory => requestfactory
      )
      it "Should return 'metrics checked'" do
        expect(metrics.healthstatus).to eq("metrics checked")
      end
    end
  end
end