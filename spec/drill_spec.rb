require 'approvals'
require 'kadryll'

def default_template
  <<-DRILL
    e42 4/4
    tt4 r4 tt4-> r4
    r4 tt4 r4 tt4
    tt4 r4 r4 tt4
    r1
  DRILL
end

describe Kadryll::Drill do
  before(:all) do
    Approvals.configure do |c|
      c.approvals_path = 'spec/fixtures/approvals/'
    end
  end

  describe "the name" do
    it "it defaults to the name passed in" do
      Kadryll::Drill.new("whatever", nil, nil).name.should eq("whatever")
    end

    it "adds a prefix if there is one" do
      Kadryll::Drill.new("whatever", nil, nil, :prefix => 'level1').name.should eq("level1_whatever")
    end

    it "sanitizes the name" do
      Kadryll::Drill.new("w_^h%$a&t.ev-er !", nil, nil).name.should eq("w_hat.ev-er")
    end
  end

  it "creates the correct lilypond command" do
    drill = Kadryll::Drill.from_string(default_template)
    executable = Approvals::Executable.new(drill.command) do |command|
      Approvals::Reporters::FilelauncherReporter.report(drill.generate_png)
    end
    Approvals.verify(executable, :name => 'drill uses the correct command')
  end

  it "creates the correct template" do
    drill = Kadryll::Drill.from_string(default_template)
    executable = Approvals::Executable.new(drill.template) do |command|
      Approvals::Reporters::FilelauncherReporter.report(drill.generate_png)
    end
    Approvals.verify(executable, :name => 'drill generates the template')
  end

  describe "copyright" do
    after(:each) do
      Kadryll.configure do |c|
        c.copyright = nil
      end
    end

    it "is skipped entirely if it is set to empty string" do
      Kadryll.configure do |c|
        c.copyright = ''
      end
      Kadryll::Drill.new("name", "time", ["measures"]).copyright.should eq("\\null")
    end

    it "uses the configuration to build the markup" do
      Kadryll.configure do |c|
        c.copyright = 'All your notes are belong to me'
      end
      copyright = Kadryll::Drill.new("name", "time", ["measures"]).copyright
      Approvals.verify(copyright, :name => 'overridden copyright')
    end
  end
end
