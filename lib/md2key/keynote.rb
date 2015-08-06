require 'unindent'

module Md2key
  class Keynote
    class << self
      def activate
        tell_keynote(<<-APPLE.unindent)
          activate
        APPLE
      end

      private

      def tell_keynote(script)
        lines = [
          'tell application "Keynote"',
          *script.split("\n").map { |l| l.prepend('  ') },
          'end tell',
        ]
        execute_applescript(lines.join("\n"))
      end

      def execute_applescript(script)
        file = Tempfile.new('applescript')
        file.write(script)
        file.close
        system('osascript', file.path)
      ensure
        file.delete
      end
    end
  end
end
