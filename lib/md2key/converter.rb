module Md2key
  class Converter
    def self.convert_markdown(path)
      abort "md2key: `#{path}` does not exist" unless File.exist?(path)

      self.new(path).generate_keynote!
    end

    def initialize(path)
      @markdown = Markdown.new(path)
    end

    def generate_keynote!
      prepare_document_base
      generate_contents
    ensure
      Keynote.delete_template_slide
    end

    private

    def prepare_document_base
      Keynote.ensure_template_slide_availability
      Keynote.delete_extra_slides
    end

    def generate_contents
      Keynote.update_cover(@markdown.cover)
      @markdown.slides.each_with_index do |slide, index|
        if slide.table
          Keynote.create_slide_with_table(slide, slide.table.rows, slide.table.columns)
          Keynote.insert_table(slide.table.data)
        else
          Keynote.create_slide(slide)
          Keynote.insert_image(slide.image) if slide.image
          Keynote.insert_code(slide.code) if slide.code
        end
        Keynote.insert_note(slide.note) if slide.note
      end
    end
  end
end
