# autorun.vim

This is a Neovim plugin that was inspired by the TJ Devries YouTube videos
{% aTargetBlank "https://www.youtube.com/watch?v=9gUatBHuXE0&t=30s",
"Automatically Execute *Anything* in Nvim" %} and {% aTargetBlank
"https://www.youtube.com/watch?v=HlfjpstqXwE&t=20s",
"Execute **anything** in neovim (now customizable)" %}.

This creates a user command named "AutoRun".
To use this:

1. Open a source file that can be executed by some shell command.
1. Open an empty buffer in a split so both are visible.
1. Get the number of the empty buffer by entering `:BufNum`
1. Entering `:AutoRun` which will prompt for three things.
1. Enter the buffer number that is output in step 3.
1. Enter a pattern that makes files that should trigger a run.
1. Enter a command to run that builds and runs a program.
