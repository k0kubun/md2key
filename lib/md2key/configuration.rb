require 'yaml'

module Md2key
  class Configuration
    class Master
      # @param [String] name - TODO: reject `nil` after Ruby 2.0 support is dropped
      # @param [TrueClass,FalseClass,nil] cover
      # @param [Integer,nil] template
      def initialize(name: nil, cover: nil, template: nil)
        @name = name
        @cover = cover
        @template = template
      end

      attr_reader :name, :cover, :template
    end

    # @param [Array<Hash{ Symbol => String,Integer,TrueClass,FalseClass }>] masters
    def initialize(masters: [])
      @masters = masters.map { |m| Master.new(**m) }
      validate!
    end

    # @return [String,nil]
    def cover_master
      master = @masters.find do |master|
        master.cover
      end
      master && master.name
    end

    # @param [Integer] level
    # @return [String,nil]
    def slide_master(level)
      master = @masters.find do |master|
        master.template == level
      end
      master && master.name
    end

    private

    def validate!
      if @masters.select(&:cover).length > 1
        abort "Config error!\n`cover: true` cannot be specified multiple times"
      end
      (1..5).each do |level|
        if @masters.select { |m| m.template == level }.length > 1
          abort "`Config error!\ntemplate: #{level}` cannot be specified multiple times"
        end
      end
    end
  end
end
