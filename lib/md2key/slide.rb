module Md2key
  class Slide < Struct.new(:title, :lines)
    def initialize(*)
      super
      self.lines ||= []
    end
  end
end
