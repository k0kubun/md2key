require 'md2key/line'
require 'md2key/slide'
require 'md2key/table'
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
          slide.lines.concat(li_lines(node))
        when 'ol'
          slide.lines.concat(li_lines(node))
        when 'table'
          row_data = []
          rows = 0
          columns = 0
          row_text = []
          node.children[0].children.each do |child|
            next if !child.is_a?(Oga::XML::Element) || child.name != 'tr'
            rows += 1
            child.children.each do |td|
              next if !td.is_a?(Oga::XML::Element) || td.name != 'th'
              columns += 1
              row_text << td.text
            end
          end
          row_data << row_text
          node.children[1].children.each do |child|
            next if !child.is_a?(Oga::XML::Element) || child.name != 'tr'
            row_text = []
            child.children.each do |td|
              next if !td.is_a?(Oga::XML::Element) || td.name != 'td'
              row_text << td.text
            end
            row_data << row_text
            rows += 1
          end
          slide.table = Table.new(rows, columns, row_data)
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
    def li_lines(ul_node, indent: 0)
      return [] unless ul_node.is_a?(Oga::XML::Element)
      return [] if ul_node.name != 'ul' && ul_node.name != 'ol'

      lines = []
      ul_node.children.each do |li_node|
        next unless li_node.is_a?(Oga::XML::Element)
        next if li_node.name != 'li'

        li_node.children.each do |node|
          case node
          when Oga::XML::Text
            text = node.text.strip
            lines << Line.new(text, indent) unless text.empty?
          when Oga::XML::Element
            next if node.name != 'ul'
            lines.concat(li_lines(node, indent: indent + 1))
          end
        end
      end
      lines
    end

    def to_xhtml(markdown)
      redcarpet = Redcarpet::Markdown.new(
        Redcarpet::Render::XHTML.new(
          escape_html: true,
        ),
        fenced_code_blocks: true, :tables => true
      )
      redcarpet.render(markdown)
    end
  end
end
