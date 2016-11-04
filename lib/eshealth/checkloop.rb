require "revolver"

module Eshealth

  # This class contains the main loop of the application
  class CheckLoop
    
    attr_accessor :period, :failures, :condition, :checks, :quell, :quellcount, :incidentids
    attr_reader :checkfactory, :alertfactory
    def initialize(options={})
      self.period = options[:period] || 3
      self.failures = options[:failures] || 3
      self.condition = options[:condition] || "green"
      self.quell = options[:quell] || 30
      self.quellcount = 0
      self.checks = Revolver.new(self.failures)
      self.incidentids = Array.new
      self.checkfactory = options[:checkfactory] || Eshealth::Checkfactory.build("FakeCheck",options)
      self.alertfactory = options[:alertfactory] || Eshealth::Alertfactory.build("FakeAlert",options)
    end

    def checkfactory=(checkfactory)
      unless checkfactory.class.superclass == Eshealth::Checkfactory
        raise "checkfactory must be a 'Eshealth::Checkfactory' not a #{checkfactory.class.superclass}"
      end
      @checkfactory = checkfactory
    end

    def alertfactory=(alertfactory)
      unless alertfactory.class.superclass == Eshealth::Alertfactory
        raise "alertfactory must be a 'Eshealth::Alertfactory' not a #{alertfactory.class.superclass}"
      end
      @alertfactory = alertfactory
    end

    # This will start the application running in an infinite loop
    def start
      puts "Starting loop\n"
      loop do
        check_health
        puts "Sleeping for #{self.period} seconds\n"
        sleep(self.period)
      end
    end

    def check_health
      puts "Running check\n"
      # Log the current health condition
      self.checks << self.checkfactory.healthstatus

      if ! status_good?
        if self.quellcount > self.quell || self.quellcount == 0
          # Alert if it's not time to quell an alert
          alert  
        else
          puts "Check failed! Quelling #{self.quell - self.quellcount + self.period} minutes.\n"
          self.quellcount += self.period
        end
      elsif self.quellcount > 0
        # The status is good, but there's been an alerts, so clear them
        clear
      end
    end

    def status_good?
      status = true
      puts self.checks.to_a.join("\n")
      if self.checks.size == self.failures
        status = false
        self.checks.to_a.each {|state| status = true if state == self.condition }
      end
      status
    end

    def alert
      puts "Check failed! Alerting.\n"
      incidentid = self.alertfactory.trigger(
        :source => self.checkfactory.type, 
        :msg => self.checkfactory.lastmsg
      )
      self.incidentids << incidentid if incidentid
      self.quellcount = self.period
    end
    
    def clear
      self.alertfactory.clear(
        :source => self.checkfactory.type, 
        :msg => self.checkfactory.lastmsg, 
        :incidentids => self.incidentids
      )
      self.quellcount = 0
    end

  end
end