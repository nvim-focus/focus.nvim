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
	-- we add +1 just incase winminwidth or height is full width/height
	vim.o.winwidth = vim.o.columns + 1
	vim.o.winheight = vim.o.lines + 1
end

M.focus_equalise = function()
	vim.o.winminwidth = 0
	vim.o.winwidth = 20
	vim.o.winminheight = 1
	vim.o.winheight = 1
	vim.cmd('wincmd=')
end

M.focus_max_or_equal = function()
	-- vim.o.winwidth does not give you the current width of the focussed display
	-- so we use a vim command winwidth(0) instead
	if vim.api.nvim_eval('winwidth(0)') > vim.o.columns / 2 then
		M.focus_equalise()
	else
		M.focus_maximise()
	end
end

return M
