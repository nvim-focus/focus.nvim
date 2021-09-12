--TODO: implement

local vim = vim
local M = {}

M.focus_enable = function()
	if vim.g.enabled_focus == 1 then
		return
	else
		vim.g.enabled_focus = 1
		require('focus').resize()
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

M.focus_maximise = function()
		vim.cmd('wincmd|')

end

M.focus_equalise = function()
		vim.o.winminwidth = 0
		vim.o.winwidth = 20
		vim.o.winminheight = 1
		vim.o.winheight = 1
		vim.cmd('wincmd=')

end

return M
