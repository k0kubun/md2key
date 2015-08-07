module Md2key
  class Markdown
    def initialize(path)
      @markdown = File.read(path)
    end

    def slides
      @slides ||= parse_markdown
    end

    private

    def parse_markdown
      slides = []
      slide  = Slide.new

      @markdown.each_line do |line|
        line = line.strip
        case line
        when /^--+$/
          # noop
        when /^# *(.+)$/
          slides << slide
          slide = Slide.new
          slide.title = $1
        when /^- *(.+)$/
          slide.lines << $1
        else
          slide.lines << line unless line.empty?
        end
      end
      slides << slide
      slides.shift unless slides.empty?
      slides
    end
  end
end
