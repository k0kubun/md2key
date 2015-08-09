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

# v0.1.1

- Fix strange indentation
  - https://github.com/k0kubun/md2key/issues/1

# v0.1.0

- Initial release
  - Parse only `#`, `-` and `---`
