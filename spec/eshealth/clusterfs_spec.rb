require "spec_helper"
require "json"

describe Eshealth::ClusterFS do
  describe "Attributes" do
    clusterfs = Eshealth::ClusterFS.new
    describe ".url" do
      it "Allows reading and writing for :url" do
        clusterfs.url = "something_stupid"
        expect(clusterfs.url).to eq("something_stupid")
      end
    end
    describe ".type" do
      it "Allows reading and writing for :type" do
        clusterfs.type = "something_stupid"
        expect(clusterfs.type).to eq("something_stupid")
      end
    end
    describe ".lastmsg" do
      it "Allows reading and writing for :lastmsg" do
        clusterfs.lastmsg = "something_stupid"
        expect(clusterfs.lastmsg).to eq("something_stupid")
      end
    end
    describe ".requestfactory" do
      it "Allows reading and writing for :requestfactory" do
        clusterfs.requestfactory = Eshealth::FakeRequest.new
        expect(clusterfs.requestfactory).to be_a(Eshealth::FakeRequest)
      end
      it "And it must be a Eshealth::RequestFactory" do
        expect { clusterfs.requestfactory = "something_stupid" }.to raise_error("requestfactory must be a 'Eshealth::Requestfactory' not a Object")
      end
    end
    describe ".percentage" do
      it "Allows reading and writing for :percentage" do
        clusterfs.percentage = 15
        expect(clusterfs.percentage).to eq(15)
      end
    end
  end
  describe "Methods" do
    describe "#healthstatus" do
      context "When at least 20\% free" do
        node = ["",{"fs" => { "data" => [{}]}}]
        node[1]["fs"]["data"][0]["free_in_bytes"] = 20
        node[1]["fs"]["data"][0]["total_in_bytes"] = 100
        nodes = {"nodes" => [node] }
        requestfactory = Eshealth::FakeRequest.new(:response => nodes.to_json)
        clusterconfig = Eshealth::ClusterFS.new(:requestfactory => requestfactory, :percentage => 20 )
        it "Should return 'green'" do
          expect(clusterconfig.healthstatus).to eq("green")
        end
      end
      context "When at less than 20\% free" do
        node = ["",{"fs" => { "data" => [{}]}}]
        node[1]["fs"]["data"][0]["free_in_bytes"] = 19
        node[1]["fs"]["data"][0]["total_in_bytes"] = 100
        nodes = {"nodes" => [node] }
        requestfactory = Eshealth::FakeRequest.new(:response => nodes.to_json)
        clusterconfig = Eshealth::ClusterFS.new(:requestfactory => requestfactory )
        it "Should return 'red'" do
          expect(clusterconfig.healthstatus).to eq("red")
        end
      end
    end
  end
end