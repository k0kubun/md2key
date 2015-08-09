require 'unindent'

module Md2key
  class Keynote
    CODE_BACKGROUND_PATH = File.expand_path('../../assets/background.png', __dir__)

    class << self
      # You must provide a first slide as a cover slide.
      def update_cover(title, sub)
        execute_applescript('update_cover', title, sub)
      end

      def ensure_template_slide_availability
        return if slides_count >= 2
        execute_applescript('ensure_template_slide_availability')
      end

      # All slides after a second slide are unnecessary and deleted.
      def delete_extra_slides
        execute_applescript('delete_extra_slides', slides_count)
      end

      def delete_template_slide
        execute_applescript('delete_template_slide')
      end

      def create_slide(title, content)
        execute_applescript('create_slide', title, content)
      end

      # Insert image to the last slide
      def insert_image(path)
        execute_applescript('insert_image', slides_count, path)
      end

      def insert_code(code)
        Highlight.pbcopy_highlighted_code(code)
        insert_code_background
        activate_last_slide
        paste_clipboard
      end

      private

      def insert_code_background
        execute_applescript('insert_code_background', slides_count, CODE_BACKGROUND_PATH)
      end

      def activate_last_slide
        execute_applescript('activate_last_slide')
      end

      def paste_clipboard
        execute_applescript('paste_clipboard')
      end

      def slides_count
        execute_applescript('slides_count').to_i
      end

      def execute_applescript(script_name, *args)
        path = script_path(script_name)
        args.map! { |arg| %Q["#{arg}"] }
        `osascript #{path} #{args.join(' ')}`
      end

      def script_path(script_name)
        scripts_path = File.expand_path('../../scripts', __dir__)
        File.join(scripts_path, "#{script_name}.scpt")
      end
    end
  end
end
