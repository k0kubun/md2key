module Md2key
  class Converter
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def convert!(path)
      prepare_document_base
      markdown = Markdown.new(path)
      generate_contents(markdown)
    ensure
      Keynote.delete_template_slide
    end

    private

    def prepare_document_base
      Keynote.ensure_template_slide_availability
      Keynote.delete_extra_slides
    end

    def generate_contents(markdown)
      cover_master = Keynote.fetch_master_slide_name(1)
      main_master  = Keynote.fetch_master_slide_name(2)

      Keynote.update_cover(markdown.cover, cover_master)
      markdown.slides.each do |slide|
        if slide.table
          Keynote.create_slide_with_table(slide, slide.table.rows, slide.table.columns, main_master)
          Keynote.insert_table(slide.table.data)
        else
          Keynote.create_slide(slide, main_master)
          Keynote.insert_image(slide.image) if slide.image
          Keynote.insert_code(slide.code) if slide.code
        end
        Keynote.insert_note(slide.note) if slide.note
      end
    end
  end
end
