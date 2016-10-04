module Md2key
  module Nodes
    class Slide < Struct.new(:title, :lines, :image, :code, :table, :note, :level)
      def initialize(*)
        super
        self.lines ||= []
      end
    end
  end
end
