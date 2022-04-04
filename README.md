# md2key [![Build Status](https://github.com/k0kubun/md2key/actions/workflows/main.yml/badge.svg)](https://github.com/k0kubun/md2key/actions)

Convert your markdown to keynote.

## Installation

```bash
gem install md2key
```

## Usage

1. Create a keynote document
2. Create a first slide as a cover slide
3. Create a second slide to choose a slide layout
4. Then execute `md2key markdown.md`

![](https://i.gyazo.com/9d4d00164683f516d44b3e536b3dd3e9.gif)

## Advanced Usage

1. Open master slide editor
2. Name "cover", "h1", "h2" ... "h5" to master slides
3. They will be used for the first slide, and other slides with `#`, `##` ... `#####`

![](./assets/advanced.gif)

## Features

### Basic example

The slides in the movie can be generated with following markdown.
You can separate slides with `---` just for readability.

```markdown
# The presentation
@k0kubun

## Hello world
- I'm takashi kokubun
- This is a pen
  - Nested item is available

## How are you?
- I'm fine thank you
```

### Insert image

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

### Insert table
```markdown
## table

| a | b | c |
|:--|:--|:--|
| 1 | 2 | 3 |
```

<img src='https://cloud.githubusercontent.com/assets/2607541/17286996/8dd4fdec-57ff-11e6-8766-cf35eacd363e.png' width='60%'>


### Insert flowchart & sequence diagram
<pre>
## flowchart & sequence diagram slide

```mermaid
sequenceDiagram
    Alice->Bob: Hello Bob, how are you?
    Note right of Bob: Bob thinks
    Bob-->Alice: I am good thanks!
    Bob-->John the Long: How about you John?
    Bob-->Alice: Checking with John...
    Alice->John the Long: Yes... John, how are you?
    John the Long-->Alice: Better then you!
```
</pre>

<img src='https://cloud.githubusercontent.com/assets/25447/20176322/5433159e-a758-11e6-8afb-e857a3e5dd0c.png' width='60%'>

### Insert presenter note

```markdown
# Keynote Speech

- OMG! I'm keynoting! :fearful:

^ Remember, what would Freddie Mercury do? Yes, I'm Freddie! We are the champions!!
```

### Configure master slide by header level (experimental)

You can change master slide by header level if you have `.md2key`.

See [#32](https://github.com/k0kubun/md2key/pull/32) for details.

## Creating your own template

Follow the following steps:

1. Open keynote application.
2. Create empty presentation.
3. Add **two master slides** (required) to the empty presentation:
  - First slide is the cover.
  - Second slide is the layout.

### Sample
You can start to modify and learn from [assets/default.key](https://github.com/k0kubun/md2key/blob/master/assets/default.key?raw=true).

### Important tips
In order to make md2key replaces the texts correctly you have to select `Title` and `Body` from the master template.

<img src='https://github.com/k0kubun/md2key/blob/master/assets/setup_master_slide.png?raw=true' width='40%'>

## License

MIT License
