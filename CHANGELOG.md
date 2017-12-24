# v0.9.2

- Fix error on rendering diagram

# v0.9.1

- Resurrect Ruby 2.0.0 support which is accidentally dropped in v0.9.0

# v0.9.0

- Use master slides named "cover", "h1", "h2", ...
  - See https://github.com/k0kubun/md2key/pull/46 for details

# v0.8.4

- Add `md2key listen` subcommand to update Keynote by watching file
  - https://github.com/k0kubun/md2key/pull/44
  - Thanks to @sachin21

# v0.8.3

- Resurrect Ruby 2.0.0 support to work on macOS's default environment

# v0.8.2

- Allow highlighting UTF-8 source code

# v0.8.1

- Fix bug in converting nested list

# v0.8.0

- Add `md2key init` subcommand to generate .md2key
- Allow changing master slide by .md2key
  - See https://github.com/k0kubun/md2key/pull/32 for details

# v0.7.0

- Support presenter notes
  - https://github.com/k0kubun/md2key/pull/28
  - Thanks to @amatsuda

# v0.6.1

- Add support to draw flowchart and sequence
  - https://github.com/k0kubun/md2key/pull/27
  - Thanks to @codeant

# v0.6.0

- Add table support
  - https://github.com/k0kubun/md2key/pull/25
  - Thanks to @codeant

# v0.5.2

- Use delay before paste to prevent pasting wrong text

# v0.5.1

- Escape HTML in markdown
  - https://github.com/k0kubun/md2key/issues/15
  - Thanks to @liubin
- Avoid using shell to execute AppleScript
  - https://github.com/k0kubun/md2key/issues/16
  - Thanks to @liubin

# v0.5.0

- Support nested list
  - https://github.com/k0kubun/md2key/pull/23

# v0.4.4

- Bugfix for code listing without extension
  - https://github.com/k0kubun/md2key/pull/17
  - Thanks to @ainoya

# v0.4.3

- Support relative path for images
  - https://github.com/k0kubun/md2key/pull/14
  - Thanks to @liubin

# v0.4.2

- Internal refactorings
- Drop unindent gem dependency

# v0.4.1

- Performance improvement
  - Stop generating applescript every time
  - Thanks to @bogem

# v0.4.0

- Support syntax-highlighted source code insert

# v0.3.3

- Don't pull the Keynote window in the front
- Always use the front document to convert

# v0.3.2

- You no longer need to select the second slide by hand

# v0.3.1

- Support inserting images

# v0.3.0

- Old extra slides before execution are deleted automatically
- Changed not to fail even if a second slide does not exist

# v0.2.2

- Activate a template slide automatically

# v0.2.1

- Don't skip a nested list
  - But still flattened

# v0.2.0

- Use redcarpet as markdown parser
  - Support list starting with `*`
  - Regard `#`, `##` and `###` as the same

# v0.1.2

- Temporarily support skipping `---`
  - Still expecting users to write a format like Deckset
  - https://github.com/k0kubun/md2key/pull/2
  - Thanks to @liubin

# v0.1.1

- Fix strange indentation
  - https://github.com/k0kubun/md2key/issues/1

# v0.1.0

- Initial release
  - Parse only `#`, `-` and `---`
