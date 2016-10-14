require "spec_helper"

describe Eshealth::HttpRequest do
  describe "Attributes" do
    httprequest = Eshealth::HttpRequest.new
    describe ".url" do
      it "Should allow reading and writing" do
        httprequest.url = "http://somethingstupid.com"
        expect(httprequest.url).to eq("http://somethingstupid.com")
      end
    end
  end
  describe "Methods" do
    describe "#fetch" do
      WebMock.stub_request(:get, "http://somethingstupid.com").
        with(:headers => {
          'Accept'          => '*/*', 
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 
          'Host'            => 'somethingstupid.com', 
          'User-Agent'      => 'Ruby'
        }
      ).to_return(:status => 200, :body => "somethingstupid", :headers => {}) 
      context "When it gets all valid input" do
        httprequest = Eshealth::HttpRequest.new(:url=>"http://somethingstupid.com")
        response = httprequest.fetch("")
        it "Should have a valid response" do
          expect(response).to eq("somethingstupid")
        end
      end
      context "When it gets garbage input" do
        httprequest = Eshealth::HttpRequest.new(:url=>"notauri:://somethingstupid.com:::666/")
        it "Should create output an error" do
          expect { response = httprequest.fetch("") }.to output("Unable to encode params ({}) : query conflicts with opaque\n").to_stderr
        end
      end
    end
  end
end