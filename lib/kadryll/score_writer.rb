module Kadryll
  class ScoreWriter
    attr_accessor :name
    def initialize(basename, options = {})
      self.name = [options[:prefix], basename].compact.join('_').gsub(/[^\w\.\-]/, '')
    end

    def lilypond_filename
      "#{name}.ly"
    end

    def lilypond_path
      "#{Kadryll.input_dir}#{lilypond_filename}"
    end

    def png_filename
      "#{name}.png"
    end

    def png_path
      "#{Kadryll.output_dir}#{png_filename}"
    end

    def write(template)
      Kadryll.initialize
      File.open(lilypond_path, 'w') do |file|
        file.write template
      end
    end

    def generate_png_command
      "lilypond --png --output=#{Kadryll.output_dir}#{name} #{lilypond_path}"
    end

    def generate_png
      system(generate_png_command)
    end
  end
end
