-- MP
-- These sources did all the work
--  1. https://vim.fandom.com/wiki/Remove_unwanted_spaces#Automatically_removing_all_trailing_whitespace
--  2. https://stackoverflow.com/questions/7495932/how-can-i-trim-blank-lines-at-the-end-of-file-in-vim

local M = {}


function M.clear_spaces()

    -- get tuple of cursor position before making changes
    local pos = vim.api.nvim_win_get_cursor( 0 )

    -- delete all whitespace, see source 1
    vim.cmd[[:%s/\s\+$//e]]

    -- delete all lines at end of buffer, see source 2
    vim.cmd[[:silent! 0;/^\%(\n*.\)\@!/,$d]]

    -- get row count after line deletion
    local end_row = vim.api.nvim_buf_line_count( 0 )


    --[[
        if the row value in the original cursor
        position tuple is greater than the
        line count after empty line deletion
        (meaning that the cursor was inside of
        the empty lines at the end of the file
        when they were deleted), set the cursor
        row to the last line
    ]]

    if pos[1] > end_row then
        pos[1] = end_row
    end

    vim.api.nvim_win_set_cursor( 0, pos )
end


return M
