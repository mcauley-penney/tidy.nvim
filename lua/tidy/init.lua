local v = vim
local M = {}

M.opts = {
  enabled_on_save = true,
  filetype_exclude = {},
  only_insert_lines = false,
  provide_undefined_editorconfig_behavior = false,
}

local function is_valid_bt()
  return v.bo.buftype ~= "terminal"
    and v.bo.buftype ~= "nofile"
    and v.bo.buftype ~= "prompt"
end

local function is_excluded_ft(excluded_fts)
  local ft = v.api.nvim_buf_get_option(0, "filetype")
  local contains = v.fn.has("nvim-0.10") == 1 and v.list_contains
    or v.tbl_contains
  return contains(excluded_fts, ft)
end

local function reset_cursor_pos(pos)
  local num_rows = v.api.nvim_buf_line_count(0)
  if pos[1] > num_rows then pos[1] = num_rows end
  v.api.nvim_win_set_cursor(0, pos)
end

local function trim_modified_lines()
  if not v.b.tidy_mod_lines then return end

  local new_lines = v.api.nvim_buf_get_lines(0, 0, -1, false)

  for i, val in pairs(v.b.tidy_mod_lines) do
    if val == true and new_lines[i] then
      new_lines[i] = new_lines[i]:gsub("%s+$", "")
    end
  end

  v.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
end

local function track_insert_changes()
  local cur_lines = v.api.nvim_buf_get_lines(0, 0, -1, false)

  local old_text = table.concat(v.b.tidy_start_lines, "\n")
  local new_text = table.concat(cur_lines, "\n")
  local hunks = v.diff(old_text, new_text, { result_type = "indices" })

  local changes = v.b.tidy_mod_lines

  for _, hunk in ipairs(hunks) do
    -- hunk = { start_old, len_old, start_new, len_new }
    local start_new, len_new = hunk[3], hunk[4]
    for i = start_new, start_new + len_new - 1 do
      changes[i] = true
    end
  end

  v.b.tidy_mod_lines = changes
  v.b.tidy_start_lines = cur_lines
end

function M.toggle()
  M.opts.enabled_on_save = not M.opts.enabled_on_save

  if not M.opts.enabled_on_save then
    v.notify("Tidy disabled on save", v.log.levels.WARN, { title = "Tidy" })
  else
    v.notify("Tidy enabled on save", v.log.levels.INFO, { title = "Tidy" })
  end
end

function M.run()
  local cursor_pos = v.api.nvim_win_get_cursor(0)

  if M.opts.only_insert_lines then
    trim_modified_lines()
  else
    v.cmd([[:keepjumps keeppatterns %s/\s\+$//e]])
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
      if not is_valid_bt() then return end

      v.b.tidy_start_lines = v.api.nvim_buf_get_lines(0, 0, -1, false)
      v.b.tidy_mod_lines = {}
    end,
  })

  v.api.nvim_create_autocmd("TextChangedI", {
    group = tidy_grp,
    callback = function()
      if not is_valid_bt() then return end

      track_insert_changes()
    end,
  })

  v.api.nvim_create_autocmd("BufWritePre", {
    group = tidy_grp,
    callback = function()
      if not is_valid_bt() then return end

      if
        not M.opts.enabled_on_save or is_excluded_ft(M.opts.filetype_exclude)
      then
        return
      end

      local trim_ws = true

      if vim.b.editorconfig and not vim.tbl_isempty(vim.b.editorconfig) then
        if not M.opts.provide_undefined_editorconfig_behavior then return end
        if v.b.editorconfig.trim_trailing_whitespace ~= nil then
          trim_ws = false
        end
      end

      if trim_ws then M.run() end
    end,
  })

  v.api.nvim_create_autocmd("BufWritePost", {
    group = tidy_grp,
    callback = function()
      if not is_valid_bt() then return end

      v.b.tidy_start_lines = v.api.nvim_buf_get_lines(0, 0, -1, false)
      v.b.tidy_mod_lines = {}
    end,
  })
end

return M
