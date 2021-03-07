# kakoune-snippets

***

I'm abandoning this project in favour of https://github.com/occivink/kakoune-snippets. It has all the features that this plugin has and in my opinion handles things in a more kakounesque and clean way. 
For the updated emmet support for the new plugin see [kakoune-emmet](https://github.com/JJK96/kakoune-emmet)

***

Snippets for kakoune

A combination of [emmet-cli](https://github.com/Delapouite/emmet-cli) with [snippets](https://github.com/shachaf/kak/blob/master/scripts/snippet.kak). 
This works with any text that contains snippet holes, so in the future it can be used with snippets returned from a language server.

[asciicast](https://asciinema.org/a/BFUqP7Ho1c0Ts6oManSIUMwqG)

`\$\d+|\$\{\d+(:[^\}]+)?\}` is used as the regex for the holes so it fits holes like `$0`, `${1}` or `${1:test}`. This can be adapted in the `rc/snippets.kak` file

## Dependencies

- Python3
- Python3 yaml bindings

## Setup

Make kakoune source `rc/snippets.kak` by symlinking it to your autoload directory

Symlink `bin/snippet` to `%val{config}/bin`

### Optional: Emmet support

Install [emmet-cli](https://github.com/Delapouite/emmet-cli).

Make kakoune source `rc/emmet.kak` by symlinking it to your autoload directory

Symlink `bin/emmet-call` to `%val{config}/bin`

Make sure that the emmet variable in `bin/emmet-call` points to the correct location of emmet, if necessary adapt it.

## Usage

Add mappings to your kakrc like the following

To expand the word before the cursor as a snippet defined in `snippets.yaml`

`map global insert <a-E> ' <esc>;h: snippet-word<ret>'`

To replace the next snippet hole in the file

`map global insert <a-e> '<esc>: replace-next-hole<ret>'`

### Snippets from `snippets.yaml`

The `snippet-word` command expands snippets found in `%val{config}/snippets.yaml`

These snippets follow the following pattern, one snippet per line

`{word}: {snippet}`

The files in which to look for snippets can be adapted by overwriting `%opt{snippet_files}`

### Optional: Emmet

For emmet support you can add a mapping to overwrite the default mapping for relevant filetypes like html or xml

To snippet the word before the cursor and if it is not a snippet defined in `snippets.yaml` then expand it using emmet

`map global insert <a-E> ' <esc>;h: try snippet-word catch emmet<ret>'`

