local vim = vim --> Use locals

local M = {}
function M.split_resizer(width,height) --> Only resize normal buffers, set qf to 10 always
    if vim.api.nvim_eval('g:enabled_focus') == 0 then return end
    if vim.bo.ft == 'TelescopePrompt' or vim.bo.ft == 'NvimTree' or vim.bo.ft == 'NerdTree'  or vim.bo.ft == 'CHADTree' then return end --> TODO: FIGURE OUT WHY TELESCOPE PROMPT STILL HAVING RESIZE SET
    if vim.bo.ft == 'qf' then
        vim.o.winwidth = 10
    else
        vim.o.winwidth = width --> lua print(vim.o.winwidth)
    end
    if height ~= 0 then vim.o.winheight = height --> Opt in to set height value, otherwise auto-size it
    -- Below removed for now. Windows resize e.g when telescope prompt opened
    -- else vim.cmd('wincmd=') end--> Auto-Maximize windows horizontally when in focus by DEFAULT
    end


end

return M
