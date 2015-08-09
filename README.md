# md2key

Convert your markdown to keynote.

## Usage

- 1. Create a keynote document
- 2. Create a first slide as a cover slide
- 3. Create a second slide to choose a slide layout
- 4. Then execute `gem install md2key && md2key markdown.md`

![](https://i.gyazo.com/9d4d00164683f516d44b3e536b3dd3e9.gif)

### Basic example

The slides in the movie can be generated with following markdown.  
You can separate slides with `---` just for readability.

```markdown
# The presentation
@k0kubun

## Hello world
- I'm takashi kokubun
- This is a pen

## How are you?
- I'm fine thank you
```

### Insert image

<img src='https://i.gyazo.com/c9870e72ddf35a9dbd487fad4e6968bd.png' width='60%'>

```markdown
# image slide

- This is an example
- You can insert an image

![](/Applications/Keynote.app/Contents/Resources/keynote.help/Contents/Resources/GlobalArt/AppLanding_KeynoteP4.png)
```

### Insert source code

If you have `highlight` command, you can insert syntax-highlighted source code.  
If you don't have it, execute `brew install highlight`.

<img src='https://i.gyazo.com/7ff36be267652ab567191a6d5cae1d0f.png' width='60%'>

<pre>
# ActiveRecord::Precount

```rb
Tweet.all.precount(:favorites).each do |tweet|
  p tweet.favorites.count
end
# SELECT `tweets`.* FROM `tweets`
# SELECT COUNT(`favorites`.`tweet_id`), `favorites`.`tweet_id` FROM `favorites` ...
```
</pre>

## License

MIT License
