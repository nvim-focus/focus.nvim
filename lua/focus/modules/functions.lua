
local vim = vim
local functions = {}

functions.focus_enable = function()
    if vim.g.enabled_focus == 0 then return
    else
    vim.g.enabled_focus = 0
    vim.o.winminwidth = 0
vim.o.winwidth = 20
vim.o.winminheight = 1
vim.o.winheight = 1
    end
end

return functions
