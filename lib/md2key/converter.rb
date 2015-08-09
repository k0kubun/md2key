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
      Keynote.activate
      Keynote.update_cover(@markdown.cover.title, @markdown.cover.lines.join('\n'))

      Keynote.delete_extra_slides
      Keynote.show_template_slide # to select a layout of slide
      @markdown.slides.each_with_index do |slide, index|
        Keynote.create_slide(slide.title, slide.lines.join('\n'))
      end

      Keynote.delete_template_slide
    end
  end
end
