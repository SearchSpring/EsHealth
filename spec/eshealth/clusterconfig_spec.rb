require "spec_helper"
require "json"

describe Eshealth::ClusterConfig do
  describe "Attributes" do
    clusterhealth = Eshealth::ClusterConfig.new
    describe ".url" do
      it "Allows reading and writing for :url" do
        clusterhealth.url = "something_stupid"
        expect(clusterhealth.url).to eq("something_stupid")
      end
    end
    describe ".type" do
      it "Allows reading and writing for :type" do
        clusterhealth.type = "something_stupid"
        expect(clusterhealth.type).to eq("something_stupid")
      end
    end
    describe ".lastmsg" do
      it "Allows reading and writing for :lastmsg" do
        clusterhealth.lastmsg = "something_stupid"
        expect(clusterhealth.lastmsg).to eq("something_stupid")
      end
    end
    describe ".requestfactory" do
      it "Allows reading and writing for :requestfactory" do
        clusterhealth.requestfactory = Eshealth::FakeRequest.new
        expect(clusterhealth.requestfactory).to be_a(Eshealth::FakeRequest)
      end
      it "And it must be a Eshealth::RequestFactory" do
        expect { clusterhealth.requestfactory = "something_stupid" }.to raise_error("requestfactory must be a 'Eshealth::Requestfactory' not a Object")
      end
    end
  end
  describe "Methods" do
    describe "#healthstatus" do
      context "The requestfactory returns a good response" do
        response = {"status" => "green"}
        requestfactory = Eshealth::FakeRequest.new(:response => response.to_json)
        clusterconfig = Eshealth::ClusterConfig.new(:requestfactory => requestfactory )
        it "Should return 'green'" do
          expect(clusterconfig.healthstatus).to eq("green")
        end
      end
    end
  end
end