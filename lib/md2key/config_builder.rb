module Md2key
  module ConfigBuilder
    class << self
      def build(skip_options: true)
        master_names = Keynote.fetch_master_slide_names
        masters = master_names.map.with_index do |name, i|
          build_master_config(name, i, skip_options: skip_options)
        end
        ["masters:\n", *masters].join
      end

      private

      def build_master_config(master_name, index, skip_options: true)
        "  - name: #{master_name.inspect}\n".tap do |config|
          next if skip_options

          if index == 0
            config << "    cover: true\n"
          elsif (1..3).cover?(index)
            config << "    template: #{index}\n"
          end
        end
      end
    end
  end
end
