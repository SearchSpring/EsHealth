require "json"
require "yaml"

module Eshealth

  class ClusterHealth < Checkfactory

    attr_accessor :url, :requestfactory, :healthbody, :type, :lastmsg
    attr_reader :requestfactory
    
    def initialize(options={})
      self.type = "ClusterHealth"
      self.url = options[:url] || "http://localhost:9200/"
      self.requestfactory = options[:requestfactory] || Eshealth::Requestfactory.build("HttpRequest", options)
    end

    def requestfactory=(requestfactory)
      unless requestfactory.class.superclass == Eshealth::Requestfactory
        raise "requestfactory must be a 'Eshealth::Requestfactory' not a #{requestfactory.class.superclass}"
      end
      @requestfactory = requestfactory
    end
    
    def healthstatus
      if response = self.requestfactory.fetch("_cluster/health")
        begin
          health = JSON.parse(response)
        rescue => e
          puts "Unable to parse response from ES: #{e}"
          "Fail"
        end
        
        self.lastmsg = "#{YAML.dump(health)}"
        health["status"]
      else
        "Fail"
      end
    end

  end
end
