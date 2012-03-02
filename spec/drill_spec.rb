require 'approvals'
require 'kadryll'

def default_template
  <<-DRILL
    e42 4/4
    tt4 r4 tt4-> r4
    r4 tt4 r4 tt4
    \\times 2/3 {tt8 tt8 tt8} tt4 tt4 tt4
    R4*4
  DRILL
end

describe Kadryll::Drill do
  before(:all) do
    Approvals.configure do |c|
      c.approvals_path = 'spec/fixtures/approvals/'
    end
  end

  it "creates the correct template" do
    drill = Kadryll::Drill.from_string(default_template)
    i = 1
    executable = Approvals::Executable.new(drill.template) do |template|
      writer = Kadryll::ScoreWriter.new(drill.name, :prefix => i)
      writer.write(template)
      writer.generate_png
      Approvals::Reporters::FilelauncherReporter.report(writer.png_path)
      i += 1
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
