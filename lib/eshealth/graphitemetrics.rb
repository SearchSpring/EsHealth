require "simple-graphite"

module Eshealth
  class GraphiteMetrics < Alertfactory

    attr_accessor :host, :port 

    def initialize(options={})
      self.host = options[:host] || "localhost"
      self.port = options[:port] || 2003
    end

    def trigger(options={})
      g = Graphite.new({:host => self.host, :port => self.port})
      begin
        g.push_to_graphite do | graphite |
          graphite.puts options[:msg]
          puts options[:msg]
        end
      rescue => e
        $stderr.puts "Unable to contact Graphite: #{e}"
      end
    end
    
    def clear(options={})
      return true
    end
  
  end
end 