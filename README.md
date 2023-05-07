# autorun.vim

This is a Neovim plugin that was inspired by the TJ Devries YouTube videos
{% aTargetBlank "https://www.youtube.com/watch?v=9gUatBHuXE0&t=30s",
"Automatically Execute *Anything* in Nvim" %} and {% aTargetBlank
"https://www.youtube.com/watch?v=HlfjpstqXwE&t=20s",
"Execute **anything** in neovim (now customizable)" %}.

This creates a user command named "AutoRun".
To use this:

1. Open a source file that can be executed by some shell command.
1. Enter `:vnew` to open an empty buffer in a vertical split.
1. Enter `:BufNum` to get the number of the empty buffer.
1. Enter `:AutoRun` which will prompt for three things.
1. Enter the buffer number that was output in step 3.
1. Enter a pattern that makes files that should trigger a run.
   For example, `*.lua`.
1. Enter a command to run that builds and runs a program.
   For example, `lua main.lua`.

Every time a file matches the entered pattern is saved,
the command entered in the last step will be executed.
Its output, both stdout and stderr, will be displayed
in what began as an empty buffer.

Using the example values, saving any `.lua` file
will cause the command `lua main.lua` to execute again.
This is good because it is possible that `main.lua`
uses (requires) other `.lua` files.
