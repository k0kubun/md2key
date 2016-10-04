require 'thor'

module Md2key
  class CLI < Thor
    desc 'convert MARKDOWN', 'Convert markdown to keynote'
    def convert(path)
      Converter.convert_markdown(path)
    end

    private

    # Shorthand for `md2key convert *.md`
    def method_missing(*args)
      path = args.first.to_s
      if args.length == 1 && path.end_with?('.md')
        convert(path)
      else
        return super(*args)
      end
    end
  end
end
