require 'pagerduty'

module Eshealth
  class PagerDutyAlert < Alertfactory

    attr_accessor :servicekey

    def initialize(options={})
      self.servicekey = options[:servicekey]
      raise "'servicekey' must be defined" unless defined? self.servicekey
    end

    def trigger(options={})
      pagerduty = Pagerduty.new(self.servicekey)
      
      begin
        incident = pagerduty.trigger(options[:msg])
      rescue => e
        $stderr.puts "Unable to contact PagerDuty: #{e}"
      end
    
    end
    
    def clear(options={})
      pagerduty = Pagerduty.new(self.servicekey)
      options[:incidentids].each do |incidentid|
        begin
          incident = pagerduty.get_incident(incidentid)
        rescue => e
          $stderr.puts "Unable to retrieve incidentid #{incidentid}: #{e}"
        end
        
        begin
          incident.resolve   
        rescue => e
          $stderr.puts "Unable to resolve incident #{incidentid} : #{e}"
        end
      end
    
    end
  
  end
end 