module Kadryll

  class CLI < Thor

    desc "generate", "Generate drills from a file with score shorthand"
    method_option :input, :type => :string, :aliases => "-i", :required => true, :desc => "path to template file"
    method_option :output, :type => :string, :default => './', :aliases => "-o", :desc => "path to output directory"
    method_option :prefix, :type => :string, :default => nil, :aliases => "-p", :desc => "file prefix for the .png output"
    method_option :copyright, :type => :string, :default => '', :aliases => "-c", :desc => "Copyright notice"
    def generate
      Kadryll.configure do |c|
        c.output_dir = options[:output]
        c.copyright = options[:copyright]
      end
      exercises = Kadryll::ShorthandReader.read(options[:input])
      exercises.each do |exercise|
        drill = Kadryll::Drill.from_string(exercise, :prefix => options[:prefix])
        drill.generate_png
      end
    end
  end
end

