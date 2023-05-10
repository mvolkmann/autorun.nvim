local function output_lines(bufnr, start_line, hl_group, lines)
  -- Output the lines.
  local end_line = -1
  local strict_indexing = false
  vim.api.nvim_buf_set_lines(
    bufnr, start_line, end_line, strict_indexing, lines
  )

  -- Apply highlighting to the lines that were just output.
  local ns_id = 0 -- creates a temporary namespace
  local col_start = 0 -- beginning of line
  local col_end = -1 -- end of line
  local end_line = start_line + #lines - 1
  for line = start_line, end_line do
    vim.api.nvim_buf_add_highlight(
      bufnr, ns_id, hl_group, line, col_start, col_end
    )
  end
end

-- Open a new buffer in a vertical split.
vim.api.nvim_command("vnew")
vim.api.nvim_command("setlocal buftype=nofile")

-- Get the buffer number of the new buffer.
local bufnr = vim.api.nvim_get_current_buf()

local start = 0
local lines = {"Line 1", "Line 2"}
output_lines(bufnr, start, "Error", lines)

start = start + #lines
local lines = {"Line 3", "Line 4"}
output_lines(bufnr, start, "Search", lines)
