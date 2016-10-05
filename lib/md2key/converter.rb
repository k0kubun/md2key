require 'md2key/keynote'

module Md2key
  class Converter
    attr_reader :config

    def initialize(config)
      @config = config
    end

    # @param [Md2key::Nodes::Presentation] presentation
    def convert!(presentation)
      prepare_document_base
      generate_contents(presentation)
    ensure
      Keynote.delete_template_slide
    end

    private

    def prepare_document_base
      Keynote.ensure_template_slide_availability
      Keynote.delete_extra_slides
    end

    def generate_contents(presentation)
      cover_master = Keynote.fetch_master_slide_name(1)
      main_master  = Keynote.fetch_master_slide_name(2)

      Keynote.update_cover(presentation.cover, config.cover_master || cover_master)
      presentation.slides.each do |slide|
        master = config.slide_master(slide.level) || main_master
        if slide.table
          Keynote.create_slide_with_table(slide, slide.table.rows, slide.table.columns, master)
          Keynote.insert_table(slide.table.data)
        else
          Keynote.create_slide(slide, master)
          Keynote.insert_image(slide.image) if slide.image
          Keynote.insert_code(slide.code) if slide.code
        end
        Keynote.insert_note(slide.note) if slide.note
      end
    end
  end
end
