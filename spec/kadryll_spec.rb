require 'kadryll'
require 'timecop'

describe Kadryll do

  describe "output dir" do
    after(:each) do
      Kadryll.configure do |c|
        c.output_dir = nil
      end
    end

    it "is drills/ by default" do
      Kadryll.output_dir.should eq('drills/scores/')
    end

    it "handles trailing slashes" do
      Kadryll.configure do |c|
        c.output_dir = 'other/dir'
      end

      Kadryll.output_dir.should eq('other/dir/')
    end
  end

  describe "input dir" do
    after(:each) do
      Kadryll.configure do |c|
        c.input_dir = nil
      end
    end

    it "is drills/data/ by default" do
      Kadryll.input_dir.should eq('drills/data/')
    end

    it "can be overridden" do
      Kadryll.configure do |c|
        c.input_dir = 'other/dir'
      end

      Kadryll.input_dir.should eq('other/dir/')
    end
  end

  describe "copyright" do
    before(:each) do
      Timecop.travel(Time.utc(2012, 2, 7, 18, 28, 18))
    end

    after(:each) do
      Kadryll.configure do |c|
        c.copyright = nil
      end
      Timecop.return
    end

    it "defaults to kadryll" do
      Kadryll.copyright.should eq('Copyright 2012 YourName')
    end

    it "can be overridden" do
      Kadryll.configure do |c|
        c.copyright = 'ALL NOTES ARE BELONG TO ME'
      end
      Kadryll.copyright.should eq('ALL NOTES ARE BELONG TO ME')
    end

  end

end
