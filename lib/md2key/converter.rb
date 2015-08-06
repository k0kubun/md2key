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
      @markdown.slides.each_with_index do |slide, index|
        if index == 0
          Keynote.update_master(slide.title, slide.lines.join("\n"))
          next
        end
        Keynote.create_slide(slide.title, slide.lines.join("\n"))
      end
      Keynote.delete_template_slide
    end
  end
end
