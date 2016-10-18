require 'spec_helper'
require 'pp'
require 'json'

describe Eshealth::PagerDutyAlert do
  describe "Attributes" do
    pagerduty = Eshealth::PagerDutyAlert.new
    describe ".servicekey" do
      it "Should allow reading and writing for :servicekey" do
        pagerduty.servicekey = "somethingstupid"
        expect(pagerduty.servicekey).to eq("somethingstupid")
      end
    end
  end
  describe "Methods" do

    context "#trigger" do
      before(:context) do
        fakereturn = { "status" => "success" }
        WebMock.stub_request(:any, "https://events.pagerduty.com/generic/2010-04-15/create_event.json").to_return(:status => 200, :body => fakereturn.to_json, :headers => {})
      end     
      pagerduty = Eshealth::PagerDutyAlert.new(:servicekey => "somethingstupid")
      it "Should make a request to PagerDuty and return a PagerdutyIncident" do
        response = pagerduty.trigger(:msg => "somethingstupid")
        expect(response).to be_a PagerdutyIncident
      end
    end
    describe "#clear" do
      before(:each) do
        fakereturn = { "status" => "success" }
        WebMock.stub_request(:post, "https://events.pagerduty.com/generic/2010-04-15/create_event.json").to_return(:status => 200, :body => fakereturn.to_json, :headers => {})
      end
      pagerduty = Eshealth::PagerDutyAlert.new(:servicekey => 222)
      it "Should make a request to PagerDuty and return a PagerDutyAlert" do
        response = pagerduty.clear(:incidentids=>[111])
        expect(response).to eq([111])
      end
    end
  end
end