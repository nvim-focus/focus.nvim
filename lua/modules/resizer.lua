local vim = vim --> Use locals

local M = {}
function M.split_resizer(config) --> Only resize normal buffers, set qf to 10 always
    local ft = vim.bo.ft
    if ft == 'NvimTree' or ft == 'nerdtree'  or ft == 'CHADTree' then
        vim.o.winwidth = config.treewidth
    elseif ft == 'qf' then
        vim.o.winheight = 10
    else
        vim.o.winwidth = config.width --> lua print(vim.o.winwidth)
    end
    if config.height ~= 0 then vim.o.winheight = config.height --> Opt in to set height value, otherwise auto-size it
    end

end

return M
