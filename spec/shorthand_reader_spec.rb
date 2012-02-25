require 'approvals'
require 'kadryll/shorthand_reader'
describe Kadryll::ShorthandReader do
  before(:all) do
    Approvals.configure do |c|
      c.approvals_path = 'spec/fixtures/approvals/'
    end
  end

  it "breaks an input file into exercise templates" do
    exercises = Kadryll::ShorthandReader.read("spec/fixtures/exercises.txt")
    Approvals.verify(exercises, :name => 'exercises from file')
  end

  it "ignores double blank lines" do
    exercises = Kadryll::ShorthandReader.read("spec/fixtures/exercises_with_blank_lines.txt")
    Approvals.verify(exercises, :name => 'exercises with blanks from file')
  end

end
