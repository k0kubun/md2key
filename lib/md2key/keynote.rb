module Md2key
  class Keynote
    COVER_SLIDE_INDEX    = 1
    TEMPLATE_SLIDE_INDEX = 2
    CODE_BACKGROUND_PATH = File.expand_path('../../assets/background.png', __dir__)

    class << self
      # You must provide a first slide as a cover slide.
      # @param [Md2key::Slide] slide
      def update_cover(slide)
        execute_applescript('update_slide', slide.title, slide.lines.map(&:text).join("\n"), COVER_SLIDE_INDEX)
      end

      # @param [Md2key::Slide] slide
      def create_slide(slide)
        execute_applescript('create_slide', slide.title, slide.lines.map(&:text).join("\n"), TEMPLATE_SLIDE_INDEX)
      end

      def ensure_template_slide_availability
        return if slides_count >= 2
        execute_applescript('create_empty_slide')
      end

      # All slides after a second slide are unnecessary and deleted.
      def delete_extra_slides
        execute_applescript('delete_extra_slides', slides_count)
      end

      def delete_template_slide
        execute_applescript('delete_slide', TEMPLATE_SLIDE_INDEX)
      end

      # Insert image to the last slide
      def insert_image(path)
        execute_applescript('insert_image', slides_count, File.absolute_path(path), TEMPLATE_SLIDE_INDEX)
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
        execute_applescript('activate_slide', slides_count)
      end

      def paste_clipboard
        execute_applescript('paste_clipboard')
      end

      def slides_count
        execute_applescript('slides_count').to_i
      end

      def execute_applescript(script_name, *args)
        path = script_path(script_name)
        `osascript #{path} "#{args.join('" "')}"`
      end

      def script_path(script_name)
        scripts_path = File.expand_path('../../scripts', __dir__)
        File.join(scripts_path, "#{script_name}.scpt")
      end
    end
  end
end
