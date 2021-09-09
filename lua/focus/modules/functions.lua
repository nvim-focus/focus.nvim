--TODO: implement

local vim = vim
local M = {}

M.focus_enable = function()
	if vim.g.enabled_focus == 1 then
		return
	else
		vim.g.enabled_focus = 1
		require('focus').init()
		-- vim.cmd('runtime autoload/focus.vim')
	end
end

M.focus_disable = function()
	if vim.g.enabled_focus == 0 then
		return
	else
		vim.g.enabled_focus = 0
		vim.o.winminwidth = 0
		vim.o.winwidth = 20
		vim.o.winminheight = 1
		vim.o.winheight = 1
		vim.cmd('wincmd=')
	end
end

M.focus_toggle = function()
	if vim.g.enabled_focus == 0 then
		M.focus_enable()
		return
	else
		M.focus_disable()
	end
end

return M
