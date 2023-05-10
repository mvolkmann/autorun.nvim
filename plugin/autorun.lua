local autorun = require "autorun"

vim.api.nvim_create_user_command(
  "AutoRun",
  function() autorun.run() end,
  {}
)

vim.api.nvim_create_user_command(
  "BufNum",
  function()
    local bufnr = vim.api.nvim_get_current_buf()
    print("buffer number is " .. bufnr)
  end,
  {}
)
