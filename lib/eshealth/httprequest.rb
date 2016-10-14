require "net/http"
require "uri"

module Eshealth
  class HttpRequest < Requestfactory

    attr_accessor :url
    
    def initialize(options={})
      self.url = options[:url] || "http://localhost:9200/"
    end
    
    def fetch(path,params={})
      begin
        uri = URI.parse("#{self.url}/#{path}")
      rescue => e
        $stderr.puts "Unable to parse URI (#{self.url}/#{path}) : #{e}"
        return false
      end
      begin
        uri.query = URI.encode_www_form(params)
      rescue => e
        $stderr.puts "Unable to encode params (#{params}) : #{e}"
        return false
      end
      begin
        response = Net::HTTP.get_response(uri)
        response.body
      rescue => e
        $stderr.puts "Unable to complete request: #{e}"
        false
      end
    end
  
  end
end