local v = vim
local M = {}

M.opts = {
  enabled_on_save = true,
  filetype_exclude = {},
  only_modified_lines = false,
  provide_undefined_editorconfig_behavior = false,
}


local function is_excluded_ft(excluded_fts)
  local ft = v.api.nvim_buf_get_option(0, "filetype")
  local contains = v.fn.has('nvim-0.10') == 1 and v.list_contains or v.tbl_contains
  return contains(excluded_fts, ft)
end

local function reset_cursor_pos(pos)
  local num_rows = v.api.nvim_buf_line_count(0)
  if pos[1] > num_rows then
    pos[1] = num_rows
  end
  v.api.nvim_win_set_cursor(0, pos)
end

local function remove_trailing_ws_in_range(lines, start_idx, end_idx)
  for i = start_idx, end_idx do
    lines[i] = lines[i]:gsub("%s+$", "")
  end
end

local function trim_modified_lines()
  if not v.b.tidy_saved_lines then
    return
  end

  local new_lines = v.api.nvim_buf_get_lines(0, 0, -1, false)

  local old_text = table.concat(v.b.tidy_saved_lines, "\n")
  local new_text = table.concat(new_lines, "\n")

  local hunks = v.diff(old_text, new_text, { result_type = "indices" })

  for _, hunk in ipairs(hunks) do
    -- hunk = { start_old, len_old, start_new, len_new }
    local start_new, len_new = hunk[3], hunk[4]
    if len_new > 0 then
      remove_trailing_ws_in_range(new_lines, start_new, start_new + len_new - 1)
    end
  end

  v.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
end

function M.toggle()
  M.opts.enabled_on_save = not M.opts.enabled_on_save

  if not M.opts.enabled_on_save then
    v.notify("Tidy disabled on save", v.log.levels.WARN, { title = "Tidy" })
  else
    v.notify("Tidy enabled on save", v.log.levels.INFO, { title = "Tidy" })
  end
end

function M.run(trim_ws)
  local cursor_pos = v.api.nvim_win_get_cursor(0)

  if trim_ws then
    if M.opts.only_modified_lines then
      trim_modified_lines()
    else
      v.cmd([[:keepjumps keeppatterns %s/\s\+$//e]])
    end
  end

  v.cmd([[:keepjumps keeppatterns silent! 0;/^\%(\n*.\)\@!/,$d_]])

  reset_cursor_pos(cursor_pos)
end

function M.setup(opts)
  M.opts = v.tbl_extend("force", M.opts, opts or {})

  local tidy_grp = v.api.nvim_create_augroup("tidy", { clear = true })

  v.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = tidy_grp,
    callback = function()
      v.b.tidy_saved_lines = v.api.nvim_buf_get_lines(0, 0, -1, false)
    end
  })

  v.api.nvim_create_autocmd("BufWritePre", {
    group = tidy_grp,
    callback = function()
      if not M.opts.enabled_on_save or is_excluded_ft(M.opts.filetype_exclude) then
        return
      end

      local trim_ws = true

      if v.b.editorconfig ~= nil and not v.tbl_isempty(v.b.editorconfig) then
        if not M.opts.provide_undefined_editorconfig_behavior then
          return
        end
        if v.b.editorconfig.trim_trailing_whitespace ~= nil then
          trim_ws = false
        end
      end

      M.run(trim_ws)
    end
  })

  v.api.nvim_create_autocmd("BufWritePost", {
    group = tidy_grp,
    callback = function()
      v.b.tidy_saved_lines = v.api.nvim_buf_get_lines(0, 0, -1, false)
    end
  })
end

return M
