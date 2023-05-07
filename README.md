# autorun.vim

This is a Neovim plugin that was inspired by the TJ Devries YouTube videos
[Automatically Execute _Anything_ in Nvim](https://www.youtube.com/watch?v=9gUatBHuXE0)
and
[Execute **anything** in neovim (now customizable)](https://www.youtube.com/watch?v=HlfjpstqXwE).

This creates the user commands "BufNum" and "AutoRun".
To use them:

1. Open a source file that can be executed by some shell command.
1. Enter `:vnew` to open an empty buffer in a vertical split.
1. Enter `:BufNum` to get the number of the empty buffer.
1. Enter `:AutoRun` which will prompt for three things.
1. Enter the buffer number that was output in step 3.
1. Enter a pattern that matches files that should trigger a run.
   For example, `*.lua`.
1. Enter a command to run that builds and runs a program.
   For example, `lua main.lua`.

Every time a file that matches the pattern is saved,
the command will be executed.
Its output, both stdout and stderr, will be displayed
in the buffer in the vertical split.

Using the example values above, saving any `.lua` file
will cause the command `lua main.lua` to execute again.
This is good because it is possible that `main.lua`
uses (requires) other `.lua` files.
