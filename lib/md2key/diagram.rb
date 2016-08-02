module Md2key
  class Diagram
    class << self
      # SEQUENCE_CONFIG_PATH = File.expand_path('../../assets/mermaid_sequence.config', __dir__)
      # GANTT_CONFIG_PATH = File.expand_path('../../assets/mermaid_gantt.config', __dir__)
      def generate_image_file(code)
        ensure_mermaid_availability

        file = Tempfile.new("diagram-#{code.extension}")
        file.write(code.source)
        file.close

        output_dir = File.dirname(file.path)
        image_path = ""
        IO.popen("mermaid #{file.path} | grep 'saved png' | awk -F':' '\{print $2\}'", 'r+') do |info|
          image_path = info.read.strip
          file.unlink
        end

        return image_path
      end

      private

      def ensure_mermaid_availability
        return if system('which -s mermaid')

        abort "`mermaid` is not available. Try `npm install -g phantomjs mermaid`."
      end
    end
  end
end
