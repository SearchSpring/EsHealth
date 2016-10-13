module Eshealth

  class Checkfactory
    def self.build(type,options={})
      case type
        when 'FakeCheck' then Eshealth::FakeCheck.new(options)
        when 'ClusterHealth' then Eshealth::ClusterHealth.new(options)
      end
    end

    def type
      raise "Factory must implement type method"
    end

    def lastmsg
      raise "Factory must implement lastmsg method"
    end

    def healthstatus(options={})
      raise "Factory must implement a healthstatus method"
    end

  end
  
  class FakeCheck < Checkfactory
    attr_accessor :status, :type, :lastmsg
    def initialize(options={})
      self.type = "FakeCheck"
      self.lastmsg = "Fake Message"
      self.status = options[:status] || "green"
    end
    def healthstatus(options={})
      self.status
    end
  end

end