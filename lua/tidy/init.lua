local M = {}

function M.setup()
    local tidy_grp = vim.api.nvim_create_augroup("tidy", { clear = true })

    vim.api.nvim_create_autocmd("BufWritePre", {
        group = tidy_grp,
        callback = function()
            local pos = vim.api.nvim_win_get_cursor(0)

            vim.cmd([[:keepjumps keeppatterns %s/\s\+$//e]])

            -- delete all lines at end of buffer, see source 2
            vim.cmd([[:keepjumps keeppatterns silent! 0;/^\%(\n*.\)\@!/,$d]])

            -- get row count after line deletion
            local last_row = vim.api.nvim_buf_line_count(0)

            --[[
                if the row value in the original cursor
                position tuple is greater than the
                line count after empty line deletion
                (meaning that the cursor was inside of
                the group of empty lines at the end of
                the file when they were deleted), set
                the cursor row to the last line.
            ]]
            if pos[1] > last_row then
                pos[1] = last_row
            end

            vim.api.nvim_win_set_cursor(0, pos)
        end,
    })
end

return M
