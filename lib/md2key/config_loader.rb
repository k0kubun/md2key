require 'md2key/configuration'

module Md2key
  class ConfigLoader
    class << self
      def load
        config = {}
        config.merge!(load_if_available(File.expand_path('~/.md2key')))
        config.merge!(load_if_available(File.expand_path('./.md2key')))
        Configuration.new(symbolize_keys(config))
      end

      private

      def load_if_available(path)
        if File.exist?(path)
          YAML.load(File.read(path))
        else
          {}
        end
      end

      def symbolize_keys(object)
        case object
        when Hash
          Hash.new.tap do |result|
            object.each do |key, value|
              result[key.to_sym] = symbolize_keys(value)
            end
          end
        when Array
          object.map(&method(:symbolize_keys))
        else
          object
        end
      end
    end
  end
end
