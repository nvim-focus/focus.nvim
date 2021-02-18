local vim = vim --> Use locals

local M = {}
function M.split_resizer(config) --> Only resize normal buffers, set qf to 10 always
    if vim.api.nvim_eval('g:enabled_focus') == 0 then return end
    if vim.bo.ft == 'NvimTree' or vim.bo.ft == 'NerdTree'  or vim.bo.ft == 'CHADTree' then return end
    if vim.bo.ft == 'qf' then
        vim.o.winwidth = 10
    else
        vim.o.winwidth = config.width --> lua print(vim.o.winwidth)
    end
    if config.height ~= 0 then vim.o.winheight = config.height --> Opt in to set height value, otherwise auto-size it
    end

end

return M
