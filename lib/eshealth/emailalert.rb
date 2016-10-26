require 'net/smtp'

module Eshealth
  class Emailalert < Alertfactory
    attr_accessor :smtp, :user, :password
    attr_reader :from_email, :to_email, :port, :logintype
    def initialize(options={})
      @emailregex = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
      self.from_email = options[:from_email]
      self.to_email = options[:to_email]
      self.smtp = options[:smtp] || "localhost"
      self.port = options[:port] || 25
      self.user = options[:user]
      self.password = options[:password]
      self.logintype = options[:logintype] || "login"
    end

    def from_email=(from_email)
      raise "Not a proper email address : '#{from_email}'" unless @emailregex.match(from_email)
      @from_email = from_email
    end

    def to_email=(to_email)
      raise "Not a proper email address : '#{to_email}'" unless @emailregex.match(to_email)
      @to_email = to_email
    end

    def port=(port)
      raise "'port' must be an INT" unless port.is_a? Integer
      @port = port
    end

    def logintype=(logintype)
      raise "logintype must be either plain, login or cram_md5" unless ['plain','login','cram_md5'].include? logintype
      @logintype = logintype
    end

    def trigger(options={})
      msg = "Alert: #{options[:msg]}"
      email(msg)
    end
    
    def clear(options={})
      msg = "Clear Alert: #{options[:msg]}"
      email(msg)
    end

    private

    def email(msg)
      msg = msg
      if self.user
        smtp = Net::SMTP.start(
          self.smtp, 
          self.port, 
          self.user, 
          self.password, 
          self.logintype
        )
      else
          smtp = Net::SMTP.start(
            self.smtp, 
            self.port
          )
      end

      smtp.send_message msg, self.from_email, self.to_email
      begin
        smtp.finish
      rescue => e
        $stderr.puts "Error sending email: #{e}"
      end 
    end
  
  end
end