require "json"
require "yaml"
require "eshealth/utilities"
require "pp"

module Eshealth
  class Metrics < Checkfactory
    
    attr_accessor :url, :type, :prefix, :lastmsg
    attr_reader :requestfactory, :metrics

    def initialize(options={})
      self.type = "metricHeap"
      self.url = options[:url] || "http://localhost:9200"
      self.metrics = options[:metrics] || [ "jvm.mem.heap_used_in_bytes" ]
      self.prefix = options[:prefix]
      self.requestfactory = options[:requestfactory] || Eshealth::Requestfactory.build("HttpRequest",options)
    end

    def requestfactory=(requestfactory)
      unless requestfactory.class.superclass == Eshealth::Requestfactory
        raise "requestfactory must be a 'Eshealth::Requestfactory' not a #{requestfactory.class.superclass}"
      end
      @requestfactory = requestfactory
    end

    def metrics=(metrics)
      unless metrics.class == Array
        raise "metrics must be an Array not a #{metrics.class}"
      end
      @metrics = metrics
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
        self.metrics.each do |metric_name|
            metric_value = ""
            begin 
              metric_value = node[1].dig(metric_name)
            rescue => e
              $stderr.puts "Unable to retrive metric : #{metric_name}\n"
              next
            end
            name = node[1].dig("name").downcase
            msg += "#{self.prefix}.#{name}.#{metric_name} #{metric_value} #{Time.now.to_i}\n"
        end
      end
      self.lastmsg = msg
      "metrics checked"
    end
  end
end