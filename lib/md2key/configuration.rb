require 'yaml'

module Md2key
  class Configuration
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
