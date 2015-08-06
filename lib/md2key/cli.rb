require 'thor'

module Md2key
  class CLI < Thor
    desc 'convert MARKDOWN', 'Convert markdown to keynote'
    def convert(file)
      puts 'hello world'
    end

    private

    def method_missing(*args)
      return super(*args) if args.length > 1
      default_task(args.first.to_s)
    end

    def default_task(arg)
      convert(arg)
    end
  end
end
