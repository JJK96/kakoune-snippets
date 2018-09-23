# Snippets
# Based on: https://github.com/shachaf/kak/blob/master/scripts/snippet.kak
# Adaptations have been made by me

# TODO: Maybe let snippets use %opt{indentwidth} or something to indent correctly?

declare-option -docstring %{
  A snippet program that should take a snippet file and optional snippet name, and:
    * Print a list of snippet names (for completion) when run with no snippet name.
    * Return 0 and print a snippet when run with a valid snippet name.
    * Return 1 when run with an invalid snippet name.} \
  str snippet_program

declare-option -docstring 'path to snippet files' \
  str-list snippet_files

declare-option -docstring 'search pattern for snippet holes' \
  str snippet_hole_pattern '\$\d+'

def replace-next-hole %{
  eval -save-regs 'ab/' %{
    try %{
      exec '"aZ'
      reg / %opt{snippet_hole_pattern}
      exec '<space>h/<ret>'
      exec -save-regs '' %{<a-*>"aZ%s<ret>"bZ"az"b<a-z>a}
      exec -with-hooks '<a-c>'
    } catch %{
      exec '"az'
      fail 'No holes found.'
    }
  }
}
def select-word \
  -docstring 'select a word which can later be be used to :snippet or :emmet' \
%{
    execute-keys '<esc><a-?>\h+|^<ret>'
}


def snippet-word \
  -docstring ':snippet the selected word' \
  %{
  eval -save-regs 'ab' %{
    try %{
      exec '"aZ'
      select-word
      exec '_"by' # trim and copy word
      exec "$%opt{snippet_program} %opt{snippet_files} -- '%reg{b}'<ret>" # abort if not valid snippet
      exec '<a-d>' # delete snippet name
      snippet "%reg{b}" # If there are multiple cursors, we assume they're all on the same snippet.
    } catch %{
      exec '"az'
      exec -with-hooks i
      fail "not a snippet"
    }
  }
}

def snippet \
  -docstring %{Insert snippet at cursor and start typing at first hole.} -params 1 \
  -shell-candidates %{ "$kak_opt_snippet_program" $(echo $kak_opt_snippet_files | tr -d \')} %{
  eval -save-regs '|abc' %{
    try %{
      exec "!%opt{snippet_program} %opt{snippet_files} -- '%arg{1}'<ret>" 'uU' # insert and select snippet
      exec '<a-;><a-s>)"aZ "bZgi"b<a-z>u<a-;>"a<a-z>a&' # fix indentation
      exec 'h'
      replace-next-hole
    }
  }
}

set global snippet_program "%val{config}/bin/snippet"
set global snippet_files "%val{config}/snippets.yaml"
set global snippet_hole_pattern %{\$\d+|\$\{\d+(:\w+)?\}}
