require 'kadryll'
require 'approvals'

describe Kadryll::ScoreWriter do
  before(:each) do
    Kadryll.stub(:input_dir) { '/tmp/data/' }
    Kadryll.stub(:output_dir) { '/tmp/scores/' }
  end

  describe "naming" do
    it "sanitizes filenames" do
      Kadryll::ScoreWriter.new("w_^h%$a&t.ev-er !").name.should eq("w_hat.ev-er")
    end

    describe "default" do
      subject { Kadryll::ScoreWriter.new('hello') }

      its(:name) { should eq('hello') }
      its(:lilypond_filename) { should eq('hello.ly') }
      its(:png_filename) { should eq('hello.png') }
      its(:lilypond_path) { should eq('/tmp/data/hello.ly') }
      its(:png_path) { should eq('/tmp/scores/hello.png') }
    end

    describe "with prefix" do
      subject { Kadryll::ScoreWriter.new('hello', :prefix => 'yes') }

      its(:name) { should eq('yes_hello') }
      its(:lilypond_filename) { should eq('yes_hello.ly') }
      its(:png_filename) { should eq('yes_hello.png') }
      its(:lilypond_path) { should eq('/tmp/data/yes_hello.ly') }
      its(:png_path) { should eq('/tmp/scores/yes_hello.png') }
    end
  end

  describe "writing" do
    it "generates a png" do
      writer = Kadryll::ScoreWriter.new('foo')
      executable = Approvals::Executable.new(writer.generate_png_command) do |command|
        writer.write("{c' e' g'}")
        writer.generate_png
        Approvals::Reporters::FilelauncherReporter.report(writer.png_path)
      end

      Approvals.verify(executable, :name => 'score writer generates png')
    end
  end

end
