require 'redcarpet'
require 'oga'

# Parse markdown, generate AST and convert it to slides.
# This is created to be compatible with Deckset.
# See: http://www.decksetapp.com/cheatsheet/
module Md2key
  class Markdown
    def initialize(path)
      markdown = File.read(path)
      xhtml    = to_xhtml(markdown)
      @ast     = Oga.parse_xml(xhtml)
    end

    def slides
      @slides ||= generate_slides
    end

    private

    def generate_slides
      slides = []
      slide  = Slide.new

      @ast.children.each do |node|
        next unless node.is_a?(Oga::XML::Element)

        case node.name
        when /^h[1-9]$/
          # New slide by header. You can skip to write `---`.
          # This feature will be removed in the future to provide
          # more compatibility with Deckset.
          # See: https://github.com/k0kubun/md2key/pull/2
          if slides.any?
            slide = Slide.new
          end

          slides << slide
          slide.title = node.text
        when 'ul'
          node.children.each do |child_node|
            next unless child_node.is_a?(Oga::XML::Element)
            next if child_node.name != 'li'

            # TODO: implement nested list
            slide.lines << child_node.inner_text.strip
          end
        when 'p'
          slide.lines << node.text
        when 'hr'
          # noop
        end
      end
      slides
    end

    def to_xhtml(markdown)
      redcarpet = Redcarpet::Markdown.new(Redcarpet::Render::XHTML)
      redcarpet.render(markdown)
    end
  end
end
