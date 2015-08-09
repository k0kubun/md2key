require 'unindent'

module Md2key
  class Keynote
    COVER_SLIDE_INDEX    = 1
    TEMPLATE_SLIDE_INDEX = 2

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
        execute_applescript(:void, :insert_image, path)
      end

      private

      def slides_count
        execute_applescript(:int, :slides_count)
      end

      def execute_applescript(type, script_name, *args)
        path = script_path(script_name.to_s)
        command = "osascript #{path} #{args.join(' ')}"

        `#{command + ' > /dev/null'}` if type == :void
        `#{command}}`.to_i if type == :int
      end

      def script_path(script_name)
        applescripts_path = File.join(Gem::Specification.find_by_name('md2key').gem_dir, '/lib/md2key/applescripts/')
        File.join(applescripts_path, "#{script_name}.applescript")
      end
    end
  end
end
