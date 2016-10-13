require "spec_helper"

describe Eshealth::CheckLoop do
  describe "Attributes" do
    eshealth = Eshealth::CheckLoop.new
    
    describe ".period" do
      it "Allows reading and writing for :period" do
        eshealth.period = 100
        expect(eshealth.period).to eq(100)
      end
    end
    
    describe ".failures" do
      it "Allows reading and writing for :failures" do
        eshealth.failures = 2
        expect(eshealth.failures).to eq(2)
      end
    end

    describe ".condition" do
      it "Allows reading and writing for :condition" do
        eshealth.condition = "purple"
        expect(eshealth.condition).to eq("purple")
      end
    end

    describe ".quell" do
      it "Allows reading and writing for :quell" do
        eshealth.quell = 100
        expect(eshealth.quell).to eq(100)
      end
    end

    describe ".quellcount" do
      it "Allows reading and writing for :quellcount" do
        eshealth.quellcount = 100
        expect(eshealth.quellcount).to eq(100)
      end
    end

    describe ".checkfactory" do
      it "Allows reading and writing for :checkfactory" do
        eshealth.checkfactory = Eshealth::FakeCheck.new
        expect(eshealth.checkfactory).to be_a(Eshealth::FakeCheck)
      end
      it "And must be a Eshealth::Checkfactory" do
        expect { eshealth.checkfactory = "some bs" }.to raise_error("checkfactory must be a 'Eshealth::Checkfactory' not a Object")
      end
    end

    describe ".alertfactory" do
      it "Allows reading and writing for :alertfactory" do
        eshealth.alertfactory = Eshealth::FakeAlert.new
        expect(eshealth.alertfactory).to be_a(Eshealth::Alertfactory)
      end
      it "And must be a Eshealth::Alertfactory" do
        expect { eshealth.alertfactory = "some bs" }.to raise_error("alertfactory must be a 'Eshealth::Alertfactory' not a Object")
      end
    end

    describe ".checks" do
      it "Allows reading and writing for :checks" do
        eshealth.checks.push("red")
        expect(eshealth.checks.to_a.first).to eq("red")
      end
      it "Allows no more entries than whats :failures init with" do
        eshealth.checks << 1 << 2 << 3 << 4
        expect(eshealth.checks.size).to eq(3)
      end
    end

    describe ".incidentids" do
      it "Allows reading and writing for :incidentids" do
        eshealth.incidentids << 1
        expect(eshealth.incidentids.first).to eq(1)
      end
    end
  end

  describe "Methods" do
    describe "#check_health" do
      eshealth = Eshealth::CheckLoop.new
      it "Run successfully" do
        eshealth.check_health
        expect(eshealth.checks.to_a.first).to eq("green") 
      end
    end
  
    describe "#status_good?" do
      eshealth = Eshealth::CheckLoop.new
      it "Should return 'green'" do
        expect(eshealth.status_good?).to be_truthy
      end
    end

    describe "#alert" do
      eshealth = Eshealth::CheckLoop.new
      it "Should add to quellcount" do
        quellcount = eshealth.quellcount
        eshealth.alert
        expect(eshealth.quellcount).to be > quellcount
      end
    end

    describe "#clear" do
      eshealth = Eshealth::CheckLoop.new
      it "Should set quellcount to 0" do
        eshealth.quellcount = 100
        eshealth.clear
        expect(eshealth.quellcount).to eq(0)
      end
    end

  end

end