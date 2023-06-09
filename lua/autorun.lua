local ns_id = 0 -- creates a temporary namespace
local start_line = 0
local strict_indexing = false

local function output_lines(bufnr, start_line, hl_group, lines)
  -- Output the lines.
  local end_line = -1
  vim.api.nvim_buf_set_lines(
    bufnr, start_line, end_line, strict_indexing, lines
  )

  -- Apply highlighting to the lines that were just output.
  local col_start = 0 -- beginning of line
  local col_end = -1 -- end of line
  local end_line = start_line + #lines - 1
  for line = start_line, end_line do
    vim.api.nvim_buf_add_highlight(
      bufnr, ns_id, hl_group, line, col_start, col_end
    )
  end
end

local function append_lines(bufnr, is_error, lines)
    
  local have_lines = #lines > 1 or (#lines == 1 and lines[1] ~= "")

  if have_lines then
    local title = is_error and "stderr" or "stdout"

    output_lines(bufnr, start_line, "Directory", {title})
    start_line = start_line + 1

    local hl_group = is_error and "Error" or "Normal"
    output_lines(bufnr, start_line, hl_group, lines)
    start_line = start_line + #lines
  end

  -- Move focus back to the previous buffer.
  -- vim.api.nvim_input("<C-w>h")
end

local function attach_to_buffer(bufnr, pattern, command)
  function run()
    -- Clear the buffer.
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, strict_indexing, {})
    start_line = 0

    vim.fn.jobstart(command, {
      stdout_buffered = true, -- only send complete lines
      on_stdout = function(_, lines) append_lines(bufnr, false, lines) end,
      on_stderr = function(_, lines) append_lines(bufnr, true, lines) end
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

      start_line = 0
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
