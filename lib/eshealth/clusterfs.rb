require "json"
require "yaml"

module Eshealth
  class ClusterFS < Checkfactory
    
    attr_accessor :url, :configbody, :type, :lastmsg, :percentage
    attr_reader :requestfactory

    def initialize(options={})
      self.type = "ClusterFS"
      self.url = options[:url] || "http://localhost:9200"
      self.requestfactory = options[:requestfactory] || Eshealth::Requestfactory.build("HttpRequest",options)
      self.percentage = options[:percentage] || 20
    end

    def requestfactory=(requestfactory)
      unless requestfactory.class.superclass == Eshealth::Requestfactory
        raise "requestfactory must be a 'Eshealth::Requestfactory' not a #{requestfactory.class.superclass}"
      end
      @requestfactory = requestfactory
    end

    def healthstatus
      percentage = self.percentage.to_f / 100.to_f rescue 0
      begin
        response = self.requestfactory.fetch("_nodes/stats/fs")
      rescue => e
        $stderr.puts "Unable to retrieve config: #{e}"
      end
      begin
        fs = JSON.parse(response)
      rescue => e
        $stderr.puts "Unable to parse response: #{e}"
      end
      fs["nodes"].each do |node|
        free = node[1]["fs"]["data"][0]["free_in_bytes"].to_f / node[1]["fs"]["data"][0]["total_in_bytes"].to_f rescue 0
        $stdout.puts "Free: #{(free * 100).to_i}%\n"
        if free < percentage
          return "red"
        end
      end
      "green"
    end
  end
end