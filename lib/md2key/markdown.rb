require 'md2key/line'
require 'md2key/slide'
require 'oga'
require 'redcarpet'

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

    # @return [Md2key::Slide]
    def cover
      cached_slides.first
    end

    # @return [Array<Md2key::Slide>]
    def slides
      cached_slides[1..-1]
    end

    private

    def cached_slides
      @cached_slides ||= generate_slides
    end

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
          slide.lines += li_lines(node).flatten
        when 'p'
          node.children.each do |child|
            if child.is_a?(Oga::XML::Element) && child.name == 'img'
              slide.image = child.attribute('src').value
              next
            end
            slide.lines << Line.new(child.text)
          end
        when 'pre'
          node.children.each do |child|
            next if !child.is_a?(Oga::XML::Element) || child.name != 'code'
            extension = child.attribute('class') ? child.attribute('class').value : nil
            slide.code = Code.new(child.text, extension)
          end
        when 'hr'
          # noop
        end
      end
      slides
    end

    # @return [Array<Md2Key::Line>]
    def li_lines(ul_node)
      return [] unless ul_node.is_a?(Oga::XML::Element)
      return [] if ul_node.name != 'ul'

      lines = []
      ul_node.children.each do |li_node|
        next unless li_node.is_a?(Oga::XML::Element)
        next if li_node.name != 'li'

        li_node.children.each do |node|
          case node
          when Oga::XML::Text
            text = node.text.strip
            lines << Line.new(text) unless text.empty?
          when Oga::XML::Element
            next if node.name != 'ul'
            lines << li_lines(node)
          end
        end
      end
      lines
    end

    def to_xhtml(markdown)
      redcarpet = Redcarpet::Markdown.new(
        Redcarpet::Render::XHTML,
        fenced_code_blocks: true,
      )
      redcarpet.render(markdown)
    end
  end
end
