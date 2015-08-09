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
      Keynote.update_cover(@markdown.cover.title, @markdown.cover.lines.join('\n'))
      @markdown.slides.each_with_index do |slide, index|
        Keynote.create_slide(slide.title, slide.lines.join('\n'))
        Keynote.insert_image(slide.image) if slide.image
        Keynote.insert_code(slide.code) if slide.code
      end
    end
  end
end
