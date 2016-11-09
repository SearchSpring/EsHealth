require "json"
require "yaml"
require "eshealth/utilities"
require "pp"

module Eshealth
  class Metrics < Checkfactory
    
    attr_accessor :url, :type, :metrics, :lastmsg
    attr_reader :requestfactory

    def initialize(options={})
      self.type = "metricHeap"
      self.url = options[:url] || "http://localhost:9200"
      self.metrics = options[:metrics]
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
        response = self.requestfactory.fetch("_nodes/stats")
      rescue => e
        $stderr.puts "Unable to retrieve stats: #{e}"
      end
      msg = ""
      begin
        nodes = JSON.parse(response)
      rescue => e
        $stderr.puts "Unable to parse response json: #{e}"
      end
      msg = ""
      nodes["nodes"].each do |node|
        self.metrics.each do |metric|
            metric_string = node[1].dig(metric)
            name = node[1].dig("name")
            msg += "#{name}.#{metric_string} #{Time.now.to_i}\n"
        end
      end
      self.lastmsg = msg
      "metrics checked"
    end
  end
end