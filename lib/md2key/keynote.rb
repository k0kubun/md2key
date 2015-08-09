require 'unindent'

module Md2key
  class Keynote
    COVER_SLIDE_INDEX    = 1
    TEMPLATE_SLIDE_INDEX = 2

    class << self
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

      def ensure_template_slide_availability
        return if slides_count >= 2

        tell_keynote(<<-APPLE.unindent)
          tell document 1
            make new slide
          end
        APPLE
      end

      # All slides after a second slide are unnecessary and deleted.
      def delete_extra_slides
        tell_keynote(<<-APPLE.unindent)
          set theSlides to slides of document 1
          set n to #{slides_count}

          repeat with theSlide in theSlides
            if n > 2 then
              delete slide n of document 1
            end if

            set n to n - 1
          end repeat
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
            -- Workaround to select correct master slide. In spite of master slide can be selected by name,
            -- name property is not limited to be unique.
            -- So move the focus to second slide and force "make new slide" to use the exact master slide.
            move slide #{TEMPLATE_SLIDE_INDEX} to before slide #{TEMPLATE_SLIDE_INDEX}

            set newSlide to make new slide
            tell newSlide
              set object text of default title item to "#{title}"
              set object text of default body item to "#{content}"
            end tell
          end tell
        APPLE
      end

      # Insert image to the last slide
      def insert_image(path)
        tell_keynote(<<-APPLE.unindent)
          tell document 1
            set theSlide to slide #{slides_count}
            set theImage to POSIX file "#{path}"
            set docWidth to its width
            set docHeight to its height

            tell slide #{TEMPLATE_SLIDE_INDEX}
              set imgFile to make new image with properties { file: theImage, width: docWidth / 3 }
              tell imgFile
                set imgWidth to its width
                set imgHeight to its width
              end tell
            end tell

            tell theSlide
              make new image with properties { file: theImage, width: imgWidth, position: { docWidth - imgWidth - 60, docHeight / 2 - imgHeight / 2} }
            end tell
          end tell
        APPLE
      end

      private

      def slides_count
        tell_keynote(<<-APPLE.unindent).to_i
          set n to 0
          set theSlides to slides of document 1
          repeat with theSlide in theSlides
            set n to n + 1
          end repeat
          do shell script "echo " & n
        APPLE
      end

      def tell_keynote(script)
        lines = [
          'tell application "Keynote"',
          *script.split("\n"),
          'end tell',
        ]
        execute_applescript(lines.join("\n"))
      end

      def execute_applescript(script)
        file = Tempfile.new('applescript')
        file.write(script)
        file.close
        `osascript #{file.path}`.strip
      ensure
        file.delete
      end
    end
  end
end
