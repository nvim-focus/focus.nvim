--TODO: implement
--[[
local vim = vim
local M = {}

M.focus_disable = function()
    if vim.g.enabled_focus == 0 then return
    else
    vim.g.enabled_focus = 0
    vim.o.winminwidth = 0
vim.o.winwidth = 20
vim.o.winminheight = 1
vim.o.winheight = 1
print("hello")
    end
end

return M ]]

--place in init.lua
--[[ function M.focus_disable()
	require('focus.modules.functions').focus_disable()
end ]]

