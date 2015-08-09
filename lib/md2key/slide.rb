module Md2key
  class Slide < Struct.new(:title, :lines, :image)
    def initialize(*)
      super
      self.lines ||= []
    end
  end
end
