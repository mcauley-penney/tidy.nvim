local M = {
    config = {
        eof_quant = -1,
        fmts = {
            "sof",
            "eof",
            "multi",
            "ws"
        }
    }
}

function M.setup(user_config)
    -- integrate user configuration
    M.config = vim.tbl_deep_extend("force", M.config, user_config or {})

    vim.cmd[[
    augroup Tidy
        au!
        au BufWritePre * lua require( "tidy" ).tidy_up()
    augroup END
    ]]
end

function M.tidy_up()
    local cmd_mods = ":keepjumps keeppatterns silent! "

    local patterns = {
        -- delete all lines at end of buffer, see sources
        eof = [[0;/^\%(\n*.\)\@!/ + ]] .. M.config.eof_quant ..  ",$d",

        -- compress all instances of multiple newlines into one, see sources
        multi = [[:%s/\n\{2,}/\r\r/e]],

        -- delete all new lines at beginning of file
        sof = [[%s/\%^\n*/]],

        -- delete all whitespace, see sources
        ws = [[%s/\s\+$//e]]
    }

    -- get tuple of cursor position before making changes
    local pos = vim.api.nvim_win_get_cursor(0)

    -- execute chosen patterns
    for _, fmt_type in ipairs(M.config.fmts) do
        vim.cmd(cmd_mods .. patterns[fmt_type])
    end

    -- get row count after line deletion
    local end_row = vim.api.nvim_buf_line_count(0)

    --[[
        if the row value in the original cursor
        position tuple is greater than the
        line count after empty line deletion
        (meaning that the cursor was inside of
        the group of empty lines at the end of
        the file when they were deleted), set
        the cursor row to the last line
    ]]
    if pos[1] > end_row then
        pos[1] = end_row
    end

    vim.api.nvim_win_set_cursor(0, pos)
end

return M
