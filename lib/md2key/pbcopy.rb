module Md2key
  class Pbcopy
    def self.copy(str)
      IO.popen('pbcopy', 'w') do |io|
        io.write(str)
        io.close_write
      end
    end
  end
end
