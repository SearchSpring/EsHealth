require "json"
require "yaml"

module Eshealth
  class ClusterConfig < Checkfactory
    
    attr_accessor :url, :configbody, :type, :lastmsg
    attr_reader :requestfactory

    def initialize(options={})
      self.type = "ClusterConfig"
      self.url = options[:url] || "http://localhost:9200"
      self.requestfactory = options[:requestfactory] || Eshealth::Requestfactory.build("HttpRequest",options)
    end

    def requestfactory=(requestfactory)
      unless requestfactory.class.superclass == Eshealth::Requestfactory
        raise "requestfactory must be a 'Eshealth::Requestfactory' not a #{requestfactory.class.superclass}"
      end
      @requestfactory = requestfactory
    end

    def healthstatus
      begin
        response = self.requestfactory.fetch("_cat/nodes?h=node.role,master")
      rescue => e
        $stderr.puts "Unable to retrieve config: #{e}"
      end
      response.split("\n").each do |line|
        datanode, master = line.split(" ")
        if datanode == "d" && master != "-"
          self.lastmsg = "Data node is configured as possible master"
          return "red"
        end
      end
      "green" 
    end
  end
end