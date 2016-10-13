module Eshealth

  class Alertfactory
    def self.build(type,options={})
      case type
        when 'EmailAlert' then Emailalert.new(options)
        when 'FakeAlert' then FakeAlert.new(options)
      end
    end

    def trigger(options={})
      raise "Factory must implement a trigger method"
    end

    def clear(options={})
      raise "Factory must implement a clear method"
    end

  end
  
  class FakeAlert < Alertfactory
    def initialize(options={})
    end
    def trigger(options={})
      puts "This is a fake alert from: #{options[:source]} with the following message:\n#{options[:msg]}"
    end
    def clear(options={})
      puts "This is a fake clear alert from: #{options[:source]} with the following message:\n#{options[:msg]}"
    end
  end

end