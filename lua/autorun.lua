local function attach_to_buffer(bufnr, pattern, command)
  print("attached_to_buffer called")

  function run()

    local function highlight_line(line, hl_group)
      print("highlight_line: hl_group =", hl_group)
      local ns_id = -1 -- ungrouped
      local col_start = 0 -- beginning of line
      local col_end = -1 -- end of line
      vim.api.nvim_buf_add_highlight(bufnr, ns_id, hl_group, line, col_start, col_end)
    end

    local function append_data(isError, data)

      local have_data = #data > 1 or (#data == 1 and data[1] ~= "")
      print("isError = " .. isError .. ", have_data = " .. tostring(have_data))

      if have_data then
        local start = isError and -1 or 0
        local title = isError and "stderr" or "stdout"

        -- This inserts or replaces lines of text at a given buffer line.
        -- 1st argument is the buffer number.
        -- 2nd argument is the starting line number (-1 for end).
        -- 3rd argument is the ending line number.
        -- 4th argument is whether an error can be raised.
        -- 5th argument is a list of lines to be written.
        -- When start is 0, all existing lines are replaced.
        vim.api.nvim_buf_set_lines(bufnr, start, -1, false, { title })
        highlight_line(start, "Error")

        -- Add data lines at the end.
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
      end

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
    group = vim.api.nvim_create_augroup("autorun", { clear = true }),
    pattern = pattern,
    callback = run
  })

  run()
end

local M = {}

M.setup = function()
  vim.api.nvim_create_user_command(
    "AutoRun",
    function()
      local command = vim.fn.input "Command: "
      local pattern = vim.fn.input "File Pattern: "
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

-- For local testing ...
M.setup()

return M
