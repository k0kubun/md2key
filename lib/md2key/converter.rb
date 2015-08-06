module Md2key
  class Converter
    def self.convert_markdown(path)
      abort "md2key: `#{path}` does not exist" unless File.exist?(path)

      self.new(path).generate_keynote!
    end

    def initialize(path)
      @markdown = File.read(path)
    end

    def generate_keynote!
      Keynote.activate
      puts @markdown
    end
  end
end
