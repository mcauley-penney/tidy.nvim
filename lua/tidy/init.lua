local M = {}

local function is_excluded_ft(opts)
    if not opts.filetype_exclude then
        return false
    end

    local ft = vim.api.nvim_buf_get_option(0, "filetype")

    for _, entry in ipairs(opts.filetype_exclude) do
        if entry == ft then
            return true
        end
    end

    return false
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
    local tidy_grp = vim.api.nvim_create_augroup("tidy", { clear = true })

    vim.api.nvim_create_autocmd("BufWritePre", {
        group = tidy_grp,
        callback = function()
            if is_excluded_ft(opts) then
                return false
            end

            local cursor_pos = vim.api.nvim_win_get_cursor(0)

            vim.cmd([[:keepjumps keeppatterns %s/\s\+$//e]])

            -- delete all lines at end of buffer, see source 2
            vim.cmd([[:keepjumps keeppatterns silent! 0;/^\%(\n*.\)\@!/,$d]])

            reset_cursor_pos(cursor_pos)
        end,
    })
end

return M
