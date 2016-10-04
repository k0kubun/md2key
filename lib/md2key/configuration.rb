require 'yaml'

module Md2key
  class Configuration
    class << self
      def load
        config = {}
        config.merge!(load_if_available(File.expand_path('~/.md2key')))
        config.merge!(load_if_available(File.expand_path('./.md2key')))
        new(symbolize_keys(config))
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

    def initialize(masters: [])
      @masters = masters
      validate!
    end

    def cover_master
      master = @masters.find do |master|
        master[:cover]
      end
      master && master[:name]
    end

    def slide_master(level)
      master = @masters.find do |master|
        master[:template] == level
      end
      master && master[:name]
    end

    private

    def validate!
      if @masters.select { |m| m[:cover] }.length > 1
        abort "Config error!\n`cover: true` cannot be specified multiple times"
      end
      (1..5).each do |level|
        if @masters.select { |m| m[:template] == level }.length > 1
          abort "`Config error!\ntemplate: #{level}` cannot be specified multiple times"
        end
      end
    end
  end
end
