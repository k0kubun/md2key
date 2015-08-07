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
          # FIXME: support nested list
          slide.lines += li_texts(node).flatten
        when 'p'
          slide.lines << node.text
        when 'hr'
          # noop
        end
      end
      slides
    end

    def li_texts(ul_node)
      return [] unless ul_node.is_a?(Oga::XML::Element)
      return [] if ul_node.name != 'ul'

      texts = []
      ul_node.children.each do |li_node|
        next unless li_node.is_a?(Oga::XML::Element)
        next if li_node.name != 'li'

        li_node.children.each do |node|
          case node
          when Oga::XML::Text
            text = node.text.strip
            texts << text unless text.empty?
          when Oga::XML::Element
            next if node.name != 'ul'
            texts << li_texts(node)
          end
        end
      end
      texts
    end

    def to_xhtml(markdown)
      redcarpet = Redcarpet::Markdown.new(Redcarpet::Render::XHTML)
      redcarpet.render(markdown)
    end
  end
end
