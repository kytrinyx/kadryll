module Kadryll
  class ShorthandReader
    def self.read(file)
      exercises = []
      current_exercise = []
      lines = File.readlines(file)
      lines.each do |line|
        if line.gsub(/\W/, '').empty?
          exercises << current_exercise.join
          current_exercise = []
        else
          current_exercise << line
        end
      end
      exercises << current_exercise.join
      exercises.compact.reject {|e| e.empty?}
    end
  end
end
