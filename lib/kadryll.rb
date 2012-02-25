require 'fileutils'
require 'singleton'
require 'date'
require 'kadryll/drill'
require 'kadryll/shorthand_reader'

module Kadryll
  class << self

    def initialize
      FileUtils.mkdir_p(output_dir) unless File.exists?(output_dir)
      FileUtils.mkdir_p(input_dir) unless File.exists?(input_dir)
    end

    def output_dir
      config.output_dir
    end

    def input_dir
      config.input_dir
    end

    def copyright
      config.copyright
    end

    def configure(&block)
      block.call Kadryll::Configuration.instance
    end

    def config
      Kadryll::Configuration.instance
    end
  end

  class Configuration
    include Singleton

    def output_dir=(dir = '')
      @output_dir = sanitize(dir)
    end

    def output_dir
      @output_dir ||= 'drills/scores/'
    end

    def input_dir=(dir = '')
      @input_dir = sanitize(dir)
    end

    def input_dir
      @input_dir ||= 'drills/data/'
    end

    def copyright
      @copyright ||= "Copyright #{Date.today.year} YourName"
    end

    def copyright=(copyright)
      @copyright = copyright
    end

    private
    def sanitize(directory)
      directory.nil? ? directory : directory.chomp('/') + '/'
    end
  end
end
