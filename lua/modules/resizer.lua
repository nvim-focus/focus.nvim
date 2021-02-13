local vim = vim --> Use locals

local M = {}
function M.split_resizer(width) --> Only resize normal buffers, set qf to 10 always
    if vim.bo.ft == 'NvimTree' or vim.bo.ft == 'NerdTree'  or vim.bo.ft == 'CHADTree' then return end
    if vim.bo.ft == 'qf' then
        vim.o.winwidth = 10
    else
        vim.o.winwidth = width
        vim.cmd('wincmd=') --> Auto-Maximize windows horizontally when in focus
    end

end

return M
