--[[ function! ResizeSplits()
        if &ft == 'NvimTree'
                return
        elseif &ft == 'qf'
                " Always set quickfix list to a height of 10
                resize 10
                return
        else
                set winwidth=120
                wincmd =
        endif
endfunction ]]

local vim = vim --> Get vim filetype using nvim api

-- :lua print(vim.o.winwidth)
local M = {}
function M.split_resizer(width)
    if vim.bo.ft == 'NvimTree' or vim.bo.ft == 'NerdTree'  or vim.bo.ft == 'CHADTree' then return end
    if vim.bo.ft == 'qf' then
        vim.o.winwidth = 10
    else
        vim.o.winwidth = width
    end

end

return M
