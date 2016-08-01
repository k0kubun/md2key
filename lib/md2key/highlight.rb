module Md2key
  class Highlight
    DEFAULT_EXTENSION = "txt"
    class << self
      def pbcopy_highlighted_code(code)
        ensure_highlight_availability

        extension = code.extension || DEFAULT_EXTENSION

        IO.popen("highlight -O rtf -K 28 -s rdark -k Monaco -S #{extension} | pbcopy", 'w+') do |highlight|
          highlight.write(code.source)
          highlight.close
        end
      end

      private

      def ensure_highlight_availability
        return if system('which -s highlight')

        abort "`highlight` is not available. Try `brew install highlight`."
      end
    end
  end
end
