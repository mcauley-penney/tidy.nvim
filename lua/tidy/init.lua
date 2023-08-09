local M = {}

M.enabled = true

function M.toggle()
  M.enabled = not M.enabled

  if not M.enabled then
    vim.notify("Tidy disabled on save", vim.log.levels.WARN, { title = "Tidy" })
  else
    vim.notify("Tidy enabled on save", vim.log.levels.INFO, { title = "Tidy" })
  end
end

local function is_excluded_ft(opts)
  local ft = vim.api.nvim_buf_get_option(0, "filetype")
  return vim.list_contains(opts.filetype_exclude, ft)
end

local function reset_cursor_pos(pos)
  local num_rows = vim.api.nvim_buf_line_count(0)

  --[[
        if the row value in the original cursor
        position tuple is greater than the
        line count after empty line deletion
        (meaning that the cursor was inside of
        the group of empty lines at the end of
        the file when they were deleted), set
        the cursor row to the last line.
    ]]
  if pos[1] > num_rows then
    pos[1] = num_rows
  end

  vim.api.nvim_win_set_cursor(0, pos)
end

function M.setup(opts)
  local defaults = {
    filetype_exclude = {},
  }

  opts = vim.tbl_extend("force", defaults, opts or {})

	if not vim.tbl_islist(opts.filetype_exclude) then
		vim.notify(
			"tidy.nvim: filetype_exclude option must be a list-like table...",
			vim.log.levels.ERROR,
			{ title = "Tidy" }
		)
	end

  local tidy_grp = vim.api.nvim_create_augroup("tidy", { clear = true })

	vim.api.nvim_create_autocmd("BufWritePre", {
    group = tidy_grp,
    callback = function()
      if not M.enabled or is_excluded_ft(opts) or (vim.b.editorconfig ~= nil and not vim.tbl_isempty(vim.b.editorconfig)) then
        return false
      end

      local cursor_pos = vim.api.nvim_win_get_cursor(0)

      -- delete trailing whitespace
      vim.cmd([[:keepjumps keeppatterns %s/\s\+$//e]])

      -- delete lines @ eof
      vim.cmd([[:keepjumps keeppatterns silent! 0;/^\%(\n*.\)\@!/,$d_]])

      reset_cursor_pos(cursor_pos)
    end,
  })
end

return M
