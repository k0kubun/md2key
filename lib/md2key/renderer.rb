require 'md2key/configuration'
require 'md2key/keynote'

module Md2key
  class Renderer
    # Magic number index for master slide named "cover"
    COVER_LEVEL = 0

    # @param [Md2key::Configuration] config
    def initialize(config)
      @config = config
    end

    # @param [Md2key::Nodes::Presentation] ast
    def render!(ast)
      prepare_document_base
      generate_contents(ast)
    ensure
      Keynote.delete_template_slide
    end

    private

    def prepare_document_base
      Keynote.ensure_template_slide_availability
      Keynote.delete_extra_slides
    end

    # @param [Md2key::Nodes::Presentation] ast
    def generate_contents(ast)
      first_master    = Keynote.fetch_master_slide_name(1)
      second_master   = Keynote.fetch_master_slide_name(2)
      master_by_level = fetch_master_by_level

      cover_master = @config.cover_master || master_by_level.fetch(COVER_LEVEL, first_master)
      Keynote.update_cover(ast.cover, cover_master)

      ast.slides.each do |slide|
        slide_master = @config.slide_master(slide.level) || master_by_level.fetch(slide.level, second_master)

        if slide.table
          Keynote.create_slide_with_table(slide, slide.table.rows, slide.table.columns, slide_master)
          Keynote.insert_table(slide.table.data)
        else
          Keynote.create_slide(slide, slide_master)
          Keynote.insert_image(slide.image) if slide.image
          Keynote.insert_code(slide.code) if slide.code
        end

        Keynote.insert_note(slide.note) if slide.note
      end
    end

    # Find master names like "h1", "h2", ... and return { 1 => "h1", 2 => "h2" } only for available ones.
    # @return [Hash{ Integer => String }]
    def fetch_master_by_level
      masters = Keynote.fetch_master_slide_names

      {}.tap do |result|
        masters.each do |master|
          if master.match(/\Ah(?<level>[1-5])\z/)
            level = Integer(Regexp.last_match[:level])
            result[level] = master
          elsif master == 'cover'
            result[COVER_LEVEL] = 'cover'
          end
        end
      end
    end
  end
end
