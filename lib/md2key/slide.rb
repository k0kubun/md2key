module Md2key
  class Slide < Struct.new(:title, :lines, :image, :code, :table, :note)
    def initialize(*)
      super
      self.lines ||= []
    end
  end
end
