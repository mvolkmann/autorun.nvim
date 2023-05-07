local M = {}

-- I configured the key mapping <leader>x
-- to write and source the current buffer.
-- This is useful when developing a Neovim plugin.
--

local function attach_to_buffer(bufnr, pattern, command)
  -- read ":help autocmd"
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("RMV", { clear = true }),
    pattern = pattern,
    callback = function()
      local function append_data(_, data)
        -- This inserts or replaces lines of text at a given buffer line.
        -- 1st argument is the buffer number.
        -- 2nd argument is the starting line number (-1 for end).
        -- 3rd argument is the ending line number.
        -- 4th argument is whether an error can be raised.
        -- 5th argument is a list of lines to be written.
        -- TODO: How can you make this text red?
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
      end

      vim.fn.jobstart(command, {
        stdout_buffered = true, -- only send complete lines
        on_stdout = append_data,
        on_stderr = append_data
      })
    end
  })
end

M.setup = function()
  vim.api.nvim_create_user_command(
    "AutoRun",
    function()
      local bufnum = vim.fn.input "Buffer Number: "
      local pattern = vim.fn.input "File Pattern: "
      local command = vim.fn.input "Command: "
      local words = vim.split(command, " ")
      attach_to_buffer(tonumber(bufnum), pattern, words)
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
