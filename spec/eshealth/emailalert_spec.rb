require 'spec_helper'
require 'mailcrate'

describe Eshealth::Emailalert do
  describe "Attributes" do
    emailalert = Eshealth::Emailalert.new(
      :from_email => "test@test.com",
      :to_email => "test@test.com"
    )
    describe ".smtp" do
      it "Should allow reading and writing for :smtp" do
        emailalert.smtp = "somethingstupid"
        expect(emailalert.smtp).to eq("somethingstupid")
      end
    end
    describe ".user" do
      it "Should allow reading and writing for :user" do
        emailalert.user = "somethingstupid"
        expect(emailalert.user).to eq("somethingstupid")
      end
    end
    describe ".password" do
      it "Should allow reading and writing for :password" do
        emailalert.password = "somethingstupid"
        expect(emailalert.password).to eq("somethingstupid")
      end
    end
    describe ".from_email" do
      it "Should allow reading and writing for :from_email" do
        emailalert.from_email = "something@stupid.com"
        expect(emailalert.from_email).to eq("something@stupid.com")
      end
    end
    describe ".to_email" do
      it "Should allow reading and writing for :to_email" do
        emailalert.to_email = "something@stupid.com"
        expect(emailalert.to_email).to eq("something@stupid.com")
      end
    end
    describe ".port" do
      it "Should allow reading and writing for :smtp" do
        emailalert.port = 2525
        expect(emailalert.port).to eq(2525)
      end
    end
    describe ".logintype" do
      it "Should allow reading and writing for :logintype" do
        emailalert.logintype = "login"
        expect(emailalert.logintype).to eq("login")
      end
    end 
  end
  describe "Methods" do
    before(:context) do
      @server = Mailcrate.new(2525)
      @server.start
    end
    after(:context) do
      @server.stop
    end
    context "#trigger" do

      emailalert = Eshealth::Emailalert.new(
        :from_email => "test@test.com",
        :to_email => "test@test.com",
        :smtp => 'localhost',
        :port => 2525
      )
      it "Should send an email" do
        response = emailalert.trigger(:msg => "somethingstupid")
        expect(response).to be_a Net::SMTP::Response
      end
    end
    describe "#clear" do
      emailalert = Eshealth::Emailalert.new(
        :from_email => "test@test.com",
        :to_email => "test@test.com",
        :port => 2525
      )
      it "Should send an email" do
        response = emailalert.clear(:msg => "somethingstupid")
        expect(response).to be_a Net::SMTP::Response
      end
    end
  end
end