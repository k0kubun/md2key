module Md2key
  module Nodes
    class Line < Struct.new(:text, :indent)
      def initialize(*)
        super
        self.indent ||= 0
      end

      def indented?
        indent > 0
      end
    end
  end
end
