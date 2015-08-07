require 'unindent'

module Md2key
  class Keynote
    COVER_SLIDE_INDEX    = 1
    TEMPLATE_SLIDE_INDEX = 2

    class << self
      def activate
        tell_keynote(<<-APPLE.unindent)
          activate
        APPLE
      end

      # You must provide a first slide as a cover slide.
      def update_cover(title, sub)
        tell_keynote(<<-APPLE.unindent)
          tell document 1
            tell slide #{COVER_SLIDE_INDEX}
              set object text of default title item to "#{title}"
              set object text of default body item to "#{sub}"
            end tell
          end tell
        APPLE
      end

      # You must provide a second slide as a template slide.
      # This is just a workaround to select a layout of slides.
      # If you tell `make new slide`, your current slide's theme
      # will be used.
      def show_template_slide
        tell_keynote(<<-APPLE.unindent)
          show slide #{TEMPLATE_SLIDE_INDEX}
        APPLE
      end

      def delete_template_slide
        tell_keynote(<<-APPLE.unindent)
          tell document 1
            delete slide #{TEMPLATE_SLIDE_INDEX}
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
