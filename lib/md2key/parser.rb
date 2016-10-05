require 'md2key/nodes'
require 'oga'
require 'redcarpet'

# Parse markdown and generate AST.
# This is created to be compatible with Deckset as far as possible.
# See: http://www.decksetapp.com/cheatsheet/
module Md2key
  class Parser
    # @param  [String] markdown
    # @return [Md2key::Nodes::Presentation] ast
    def parse(markdown)
      slides = parse_slides(markdown)
      cover  = slides.delete_at(0)
      Nodes::Presentation.new(cover, slides)
    end

    private

    def parse_slides(markdown)
      slides = []
      slide  = Nodes::Slide.new

      html_nodes = Oga.parse_xml(to_xhtml(markdown))
      html_nodes.children.each do |node|
        next unless node.is_a?(Oga::XML::Element)

        case node.name
        when /^h(?<level>[1-9])$/
          # New slide by header. You can skip to write `---`.
          # This feature will be removed in the future to provide
          # more compatibility with Deckset.
          # See: https://github.com/k0kubun/md2key/pull/2
          if slides.any?
            slide = Nodes::Slide.new
          end

          slides << slide
          slide.title = node.text
          slide.level = Regexp.last_match[:level].to_i
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
          slide.table = Nodes::Table.new(rows, columns, row_data)
        when 'p'
          node.children.each do |child|
            if child.is_a?(Oga::XML::Element) && child.name == 'img'
              slide.image = child.attribute('src').value
              next
            elsif child.is_a?(Oga::XML::Text) && child.text.start_with?('^ ')
              slide.note = child.text.sub(/^\^ /, '')
              next
            end
            slide.lines << Nodes::Line.new(child.text)
          end
        when 'pre'
          node.children.each do |child|
            next if !child.is_a?(Oga::XML::Element) || child.name != 'code'
            extension = child.attribute('class') ? child.attribute('class').value : nil
            slide.code = Nodes::Code.new(child.text, extension)
          end
        when 'hr'
          # noop
        end
      end
      slides
    end

    # @return [Array<Md2key::Nodes::Line>]
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
            lines << Nodes::Line.new(text, indent) unless text.empty?
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
        fenced_code_blocks: true, tables: true
      )
      redcarpet.render(markdown)
    end
  end
end
