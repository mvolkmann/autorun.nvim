-- CHANGE THIS

--[[ TODO: Get this to work!
local bufnr = vim.api.nvim_get_current_buf()
local hl_group = vim.api.nvim_get_hl_by_name("Error", true)
print("hl_group =", hl_group)
-- vim.api.nvim_buf_add_highlight(bufnr, 0, "Error", 1, 1, 80)
vim.api.nvim_buf_set_extmark(bufnr, 0, hl_group, 1, {})
vim.api.nvim_buf_set_lines(bufnr, 1, 1, false, { "-- Hello, World!", "-- Line #2" }) ]]
local M = {}

local function attach_to_buffer(bufnr, pattern, command)
  function run()
    local function append_data(isError, data)
      -- This inserts or replaces lines of text at a given buffer line.
      -- 1st argument is the buffer number.
      -- 2nd argument is the starting line number (-1 for end).
      -- 3rd argument is the ending line number.
      -- 4th argument is whether an error can be raised.
      -- 5th argument is a list of lines to be written.

      -- TODO: How can you make this text red?
      -- TODO: Use vim.api.nvim_buf_set_extmark instead?
      -- TODO: Use the "Error" highlight group.
      --[[ if error then
        local hl_group = vim.api.nvim_get_hl_by_name("Error")
        vim.api.nvim_buf_add_highlight(bufnr, 0, hl_group, 1, 1, 80)
        -- vim.api.nvim_buf_set_extmark(bufnr, 0, hl_group, 1)
      end ]]
      vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
      -- Move focus back to the previous buffer.
      vim.api.nvim_input("<C-w>h")
    end

    vim.fn.jobstart(command, {
      stdout_buffered = true, -- only send complete lines
      on_stdout = function(_, data) append_data(false, data) end,
      on_stderr = function(_, data) append_data(true, data) end
    })
  end

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("RMV", { clear = true }),
    pattern = pattern,
    callback = run
  })

  run()
end

M.setup = function()
  vim.api.nvim_create_user_command(
    "AutoRun",
    function()
      local pattern = vim.fn.input "File Pattern: "
      local command = vim.fn.input "Command: "
      local words = vim.split(command, " ")

      -- Create a new buffer in a vertical split.
      -- TODO: Can you make this buffer read-only?
      vim.api.nvim_command("vnew")
      vim.api.nvim_command("setlocal buftype=nofile")
      -- Get the buffer number of the new buffer.
      local bufnr = vim.api.nvim_get_current_buf()
      -- Move focus back to the previous buffer.
      vim.api.nvim_input("<C-w>h")

      attach_to_buffer(tonumber(bufnr), pattern, words)
    end,
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
end

return M
