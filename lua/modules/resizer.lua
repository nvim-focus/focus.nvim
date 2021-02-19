local vim = vim --> Use locals
local eval = vim.api.nvim_eval
local ft = vim.bo.ft

local M = {}
function M.split_resizer(config) --> Only resize normal buffers, set qf to 10 always
    if eval('g:enabled_focus') == 0 then return end
    if ft == 'NvimTree' or ft == 'NerdTree'  or ft == 'CHADTree' then return end
    if ft == 'qf' then
        vim.o.winwidth = 10
    else
        vim.o.winwidth = config.width --> lua print(vim.o.winwidth)
    end
    if config.height ~= 0 then vim.o.winheight = config.height --> Opt in to set height value, otherwise auto-size it
    end

end

return M
