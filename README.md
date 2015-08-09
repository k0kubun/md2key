# md2key

Convert your markdown to keynote.

## Usage

- 1. Create a keynote document
- 2. Create a first slide as a cover slide
- 3. Create a second slide to choose a slide layout
- 4. Then execute `gem install md2key && md2key markdown.md`

### Example

![](https://i.gyazo.com/9d4d00164683f516d44b3e536b3dd3e9.gif)

The slides in the movie are generated from following markdown.

```markdown
# The presentation

@k0kubun

---

# Hello world

- I'm takashi kokubun
- This is a pen

---

# How are you?

- I'm fine thank you
```

This is designed to be compatible with [Deckset](http://www.decksetapp.com/).

### No horizontal lines

Currently md2key supports a short format that does not need `---`.
Headers always create a new slide.

```markdown
# The presentation
@k0kubun

## Hello world
- I'm takashi kokubun
- This is a pen

## How are you?
- I'm fine thank you
```

### Image

![](https://i.gyazo.com/c9870e72ddf35a9dbd487fad4e6968bd.png)

```markdown
# image slide

- This is an example
- You can insert an image

![](/Applications/Keynote.app/Contents/Resources/keynote.help/Contents/Resources/GlobalArt/AppLanding_KeynoteP4.png)
```

## License

MIT License
