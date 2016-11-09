require "simple-graphite"
require "json"

module Eshealth
  class GraphiteMetrics < Alertfactory

    attr_accessor :host, :port, :prefix

    def initialize(options={})
      self.host = options[:host] || "localhost"
      self.port = options[:port] || 2003
      self.prefix = options[:prefix] || "eshealth"
    end

    def trigger(options={})
      g = Graphite.new({:host => self.host, :port => self.port, :prefix => self.prefix})
      begin
        g.push_to_graphite do | graphite |
          options[:msg].split("\n").each do |line|
            graphite.puts line
            puts "#{self.prefix}.#{line}\n"
          end
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