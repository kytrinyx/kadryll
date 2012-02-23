require 'approvals'
require 'kadryll'

describe Kadryll::Drill do
  before(:all) do
    Approvals.configure do |c|
      c.approvals_path = 'spec/fixtures/approvals/'
    end
  end

  it "generates a png" do
    template = <<-DRILL
      e42 4/4
      tt4 r4 tt4-> r4
      r4 tt4 r4 tt4
      tt4 r4 r4 tt4
      r1
    DRILL
    drill = Kadryll::Drill.from_string(template)
    executable = Approvals::Executable.new(drill.to_command) do |command|
      Approvals::Reporters::FilelauncherReporter.report(drill.generate_png)
    end
    Approvals.verify(executable, :name => 'drill generates a png')
  end
end
