require 'md2key/pbcopy'
require 'md2key/diagram'
require 'erb'

module Md2key
  class Keynote
    COVER_SLIDE_INDEX    = 1
    TEMPLATE_SLIDE_INDEX = 2
    CODE_BACKGROUND_PATH = File.expand_path('../../assets/background.png', __dir__)

    class << self
      # You must provide a first slide as a cover slide.
      # @param [Md2key::Slide] slide
      def update_cover(slide, master_name)
        execute_applescript('update_slide', slide.title, slide.lines.map(&:text).join("\n"), master_name, COVER_SLIDE_INDEX)
      end

      # @param [Md2key::Slide] slide
      # @param [String] master_name
      def create_slide(slide, master_name)
        if slide.lines.any?(&:indented?)
          create_indented_slide(slide, master_name)
        else
          # Not using `create_indented_slide` because this is faster.
          execute_applescript('create_slide_and_write_body', slide.title, slide.lines.map(&:text).join("\n"), master_name, TEMPLATE_SLIDE_INDEX)
        end
      end

      # @param [Md2key::Slide] slide
      def create_slide_with_table(slide, rows, columns, master_name)
        execute_applescript('create_slide_and_insert_table', slide.title, TEMPLATE_SLIDE_INDEX, rows, columns, master_name)
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
        draw_diagram = false
        prefix = ""
        case code.extension
        when 'mermaid'
          draw_diagram = true
        when 'seq', 'sequence'
          prefix = "sequenceDiagram\n"
          draw_diagram = true
        else
          Highlight.pbcopy_highlighted_code(code)
          insert_code_background
          activate_last_slide
          paste_clipboard
        end

        if draw_diagram
          code.source = prefix + code.source
          path = Diagram.generate_image_file(code)
          insert_image(path)
          File.unlink(path)
        end
      end

      def insert_table(data)
        row_index = 1
        data.each do |row|
          param = [slides_count, row_index]
          row.each do |cell|
            param << cell
          end
          execute_applescript('update_table', *param)
          row_index += 1
        end
      end

      # Insert presenter note
      def insert_note(note)
        execute_applescript('insert_note', slides_count, note)
      end

      def fetch_master_slide_name(slide_index)
        execute_applescript('fetch_master_slide_name', slide_index).rstrip
      end

      def fetch_master_slide_names
        execute_applescript('fetch_master_slide_names').strip.split("\n")
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

      # @param [Md2key::Slide] slide
      # @param [String] master_name
      def create_indented_slide(slide, master_name)
        execute_applescript('create_slide_and_select_body', slide.title, master_name, TEMPLATE_SLIDE_INDEX)

        last_index = slide.lines.size - 1
        current_indent = 0
        slide.lines.each_with_index do |line, index|
          # Using copy and paste to input multibyte chars
          Pbcopy.copy(line.text)
          paste_and_indent(line.indent - current_indent, insert_newline: index < last_index)
          current_indent = line.indent
        end
      end

      def paste_and_indent(indent, insert_newline: true)
        execute_applescript('paste_and_indent', indent, insert_newline)
      end

      # @return [String] - script's output
      def execute_applescript(script_name, *args)
        path = script_path(script_name)
        script = ERB.new(File.read(path)).result
        IO.popen(['osascript', '-e', script, *args.map(&:to_s)], &:read)
      end

      def script_path(script_name)
        scripts_path = File.expand_path('../../scripts', __dir__)
        File.join(scripts_path, "#{script_name}.scpt.erb")
      end
    end
  end
end
