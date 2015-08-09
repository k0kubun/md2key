require 'unindent'

module Md2key
  class Keynote
    CODE_BACKGROUND_PATH = File.expand_path('../../assets/background.png', __dir__)

    class << self
      # You must provide a first slide as a cover slide.
      def update_cover(title, sub)
        execute_applescript(:void, :update_cover, title, sub)
      end

      def ensure_template_slide_availability
        return if slides_count >= 2
        execute_applescript(:void, :ensure_template_slide_availability)
      end

      # All slides after a second slide are unnecessary and deleted.
      def delete_extra_slides
        execute_applescript(:void, :delete_extra_slides, slides_count)
      end

      def delete_template_slide
        execute_applescript(:void, :delete_template_slide)
      end

      def create_slide(title, content)
        execute_applescript(:void, :create_slide, title, content)
      end

      # Insert image to the last slide
      def insert_image(path)
        execute_applescript(:void, :insert_image, slides_count, path)
      end

      def insert_code(code)
        Highlight.pbcopy_highlighted_code(code)
        insert_code_background
        activate_last_slide
        paste_clipboard
      end

      private

      def insert_code_background
        execute_applescript(:void, :insert_code_background, slides_count, CODE_BACKGROUND_PATH)
      end

      def activate_last_slide
        execute_applescript(:void, :activate_last_slide)
      end

      def paste_clipboard
        execute_applescript(:void, :paste_clipboard)
      end

      def slides_count
        execute_applescript(:int, :slides_count)
      end

      def execute_applescript(type, script_name, *args)
        path = script_path(script_name.to_s)
        args.map! { |arg|  "\"#{arg}\"" }
        command = "osascript #{path} #{args.join(' ')}"
        `#{command + ' > /dev/null'}` if type == :void
        `#{command}}`.to_i if type == :int
      end

      def script_path(script_name)
        applescripts_path = File.expand_path('applescripts', __dir__)
        File.join(applescripts_path, "#{script_name}.applescript")
      end

    end
  end
end
