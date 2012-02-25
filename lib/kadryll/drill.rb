module Kadryll
  class Drill

    class << self
      def lilypond_file(name)
        "#{Kadryll.input_dir}#{name}.ly"
      end

      def from_string(template)
        drill = parse template
        drill.write
        drill
      end

      def parse(template)
        data, *measures = template.split("\n").map(&:strip)
        name, time = data.split(" ")
        new(name, time, measures)
      end
    end

    attr_accessor :name, :time, :right_hand, :left_hand, :right_foot, :left_foot
    def initialize(name, time, measures, options = {})
      self.name = build_name(name, options[:prefix])
      self.time = time
      self.right_hand, self.left_hand, self.right_foot, self.left_foot = measures
    end

    def command
      "lilypond --png --output=#{output_to} #{lilypond_file}"
    end

    def generate_png
      system(command)
      "#{output_to}.png"
    end

    def output_to
      "#{Kadryll.output_dir}#{name}"
    end

    def write
      Kadryll.initialize
      File.open(lilypond_file, 'w') do |file|
        file.write template
      end
    end

    def lilypond_file
      Drill.lilypond_file(name)
    end

    def template
      <<-DRILL.gsub(/^\ {6}/, '')
      \\version "2.14.2"

      \\header {
        tagline = \\markup {
          \\fill-line {
            \\line { \\null }
            \\line { \\null }
            \\line { \\tiny \\with-color #(x11-color 'gray80) { #{Kadryll.copyright} \\char ##x00A9 } }

          }
        }
      }

      #(set! paper-alist (cons '("drill" . (cons (* 170 mm) (* 80 mm))) paper-alist))
      \\paper {
        #(set-paper-size "drill")
        #(define top-margin (* 7 mm))
        #(define line-width (* 120 mm))
      }

      signature = \\time #{time}

      rh = \\drummode { #{right_hand} }
      lh = \\drummode { #{left_hand} }
      rf = \\drummode { #{right_foot} }
      lf = \\drummode { #{left_foot} }

      #(define quake '((tamtam default #t 0)))
      quakestaff = {
        \\override DrumStaff.StaffSymbol #'line-positions = #'( 0 )
        \\override DrumStaff.BarLine #'bar-extent = #'(-1 . 1.5)
        \\override DrumStaff.InstrumentName #'self-alignment-X = #LEFT
        \\set DrumStaff.drumStyleTable = #(alist->hash-table quake)
        \\set fontSize = #-2
        \\signature
        \\override DrumStaff.Rest #'staff-position = #0
      }

      <<
      \\new DrumStaff {
        \\quakestaff
        \\set DrumStaff.instrumentName = "Right Hand "
        \\override Stem #'direction = #UP
        \\rh | \\rh | \\rh | \\rh |
      }
      \\new DrumStaff {
        \\quakestaff
        \\set DrumStaff.instrumentName = \\markup \\left-column {
          "Left Hand "
        }
        \\override Stem #'direction = #DOWN
        \\lh | \\lh | \\lh | \\lh
      }
      \\new DrumStaff {
        \\quakestaff
        \\set DrumStaff.instrumentName = \\markup \\left-column {
          "Right Foot "
        }
        \\override Stem #'direction = #UP
        \\rf | \\rf | \\rf | \\rf |
      }
      \\new DrumStaff {
        \\quakestaff
        \\set DrumStaff.instrumentName = \\markup \\left-column {
          "Left Foot "
        }
        \\override Stem #'direction = #DOWN
        \\lf | \\lf | \\lf | \\lf |
      }
      >>

      DRILL
    end

    private
    def build_name(name, prefix)
      [prefix, name].compact.join('_').gsub(/[^\w\.\-]/, '')
    end

  end
end
