require 'unindent'

module Md2key
  class Keynote
    class << self
      def activate
        tell_keynote(<<-APPLE.unindent)
          activate
        APPLE
      end

      def create_master(title, sub)
        tell_keynote(<<-APPLE.unindent)
          tell document 1
            tell slide 1
              set object text of default title item to "#{title}"
              set object text of default body item to "#{sub}"
            end tell
          end tell
        APPLE
      end

      def create_slide(title, content)
        tell_keynote(<<-APPLE.unindent)
          tell document 1
            set newSlide to make new slide

            tell newSlide
              set object text of default title item to "#{title}"
              set object text of default body item to "#{content}"
            end tell
          end tell
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
