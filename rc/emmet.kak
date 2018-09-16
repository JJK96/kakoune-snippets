hook global WinSetOption filetype=(html|xml) %[
    # calls to emmet-cli
    # Depends on ../bin/emmet-call
    define-command emmet %{
        execute-keys "<esc>x|%val{config}/bin/emmet-call<ret>"
        execute-keys "<esc>uU)<a-;> ;: replace-next-hole<ret>"
    }
]
