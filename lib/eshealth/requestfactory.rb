module Eshealth
  # This factory is used to communicate with Elasticsearch
  # 
  class Requestfactory

    def self.build(type,options={})
      case type
        when "FakeRequest" then FakeRequest.new(options)
        when "HttpRequest" then HttpRequest.new(options)
      end 
    end

    def fetch(path,params={})
      raise "Factory must implement a fetch method"
    end

  end

  class FakeRequest < Requestfactory

    attr_accessor :url
    
    def initialize(options={})
    end
    def fetch(path,params={})
      params[:response]
    end
  end

end