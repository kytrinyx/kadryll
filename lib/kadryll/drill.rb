module Kadryll
  class Drill

    class << self
      def from_string(template, options = {})
        drill = parse template
        writer = Kadryll::ScoreWriter.new(drill.name, :prefix => options[:prefix])
        drill.writer = writer

        writer.write(drill.template)
        drill
      end

      def parse(template)
        data, *measures = template.split("\n").map(&:strip)
        name, time = data.split(" ")
        new(name, time, measures)
      end
    end

    attr_accessor :name, :time, :right_hand, :left_hand, :right_foot, :left_foot
    attr_writer :writer
    def initialize(name, time, measures)
      self.name = name
      self.time = time
      self.right_hand, self.left_hand, self.right_foot, self.left_foot = measures
    end

    def writer
      @writer ||= Kadryll::ScoreWriter.new(name)
    end

    def to_png
      writer.generate_png
    end

    def template
      <<-DRILL.gsub(/^\ {6}/, '')
      \\version "2.14.2"

      \\header {
        tagline = \\markup {
          #{copyright}
        }
      }

      #(set! paper-alist (cons '("drill" . (cons (* 190 mm) (* 80 mm))) paper-alist))
      \\paper {
        #(set-paper-size "drill")
        #(define top-margin (* 7 mm))
        #(define line-width (* 140 mm))
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
        \\lh | \\lh | \\lh | \\lh |
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

    def copyright
      if Kadryll.copyright.empty?
        "\\null"
      else
        <<-COPYRIGHT.gsub(/^\ {6}/, '')
        \\fill-line {
          \\line { \\null }
          \\line { \\null }
          \\line { \\tiny \\with-color #(x11-color 'gray80) { #{Kadryll.copyright} \\char ##x00A9 } }
        }
        COPYRIGHT
      end
    end

  end
end
